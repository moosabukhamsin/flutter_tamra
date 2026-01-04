import UIKit
import Flutter
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import SafariServices

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase initialization - required for Firebase Phone Auth on iOS
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    
    // Request notification permissions
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle APNs token for Firebase Phone Authentication and Messaging
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Set APNs token for Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken
    
    // Set APNs token for Firebase Phone Authentication
    #if targetEnvironment(simulator)
      // Simulator environment - don't set APNs token to avoid crashes
      // Firebase Phone Auth will use ReCAPTCHA fallback automatically on Simulator
      print("ℹ️  Running on Simulator - APNs token not set, will use ReCAPTCHA fallback")
    #else
      // Real device environment - set production token
      // Important: Use .production for real devices to enable silent APNs verification
      // This helps avoid ReCAPTCHA when possible
      Auth.auth().setAPNSToken(deviceToken, type: .production)
      print("✅ APNs token set for device (production)")
    #endif
    
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  // Handle APNs token registration failure
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("⚠️ Failed to register for remote notifications: \(error.localizedDescription)")
    // On Simulator, APNs may fail - this is expected
    // Firebase Phone Auth will fall back to ReCAPTCHA on Simulator
    #if targetEnvironment(simulator)
      print("ℹ️  Running on Simulator - Firebase Phone Auth will use ReCAPTCHA fallback")
    #endif
  }
  
  // Handle remote notifications for Firebase Phone Authentication
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if Auth.auth().canHandleNotification(userInfo) {
      completionHandler(.noData)
      return
    }
    super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }
  
  // Handle URL opening for ReCAPTCHA verification
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print("🔗 App opened with URL: \(url.absoluteString)")
    // Handle Firebase Auth URL callbacks (for ReCAPTCHA)
    if Auth.auth().canHandle(url) {
      print("✅ Firebase Auth can handle URL - processing ReCAPTCHA callback")
      return true
    }
    print("⚠️ Firebase Auth cannot handle URL, passing to super")
    return super.application(app, open: url, options: options)
  }
  
  // Handle URL opening from Scene (iOS 13+) - مهم جداً لـ ReCAPTCHA
  @available(iOS 13.0, *)
  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    print("🔗 Scene opened with URL: \(url.absoluteString)")
    if Auth.auth().canHandle(url) {
      print("✅ Firebase Auth can handle URL in scene - processing ReCAPTCHA callback")
      return
    }
    print("⚠️ Firebase Auth cannot handle URL in scene")
  }
}
