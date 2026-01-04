import UIKit
import Flutter
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import SafariServices

@main
@objc class AppDelegate: FlutterAppDelegate, AuthUIDelegate {
  
  // Keep a reference to the SFSafariViewController to prevent it from being deallocated
  weak var safariViewController: SFSafariViewController?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase initialization - required for Firebase Phone Auth on iOS
    FirebaseApp.configure()
    
    // Configure Firebase Auth settings for better ReCAPTCHA handling
    Auth.auth().useAppLanguage()
    Auth.auth().settings?.isAppVerificationDisabledForTesting = false
    
    // Set AppDelegate as AuthUIDelegate for ReCAPTCHA presentation
    // This allows us to control how ReCAPTCHA is presented and kept open
    print("✅ AppDelegate configured as AuthUIDelegate for ReCAPTCHA handling")
    
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
      // Note: .unknown lets Firebase detect the environment automatically
      // On real devices, Firebase will use production APNs
      Auth.auth().setAPNSToken(deviceToken, type: .unknown)
      print("✅ APNs token set for device")
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
  
  // MARK: - AuthUIDelegate Methods
  
  /// Present ReCAPTCHA view controller - ensures it stays open longer
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
    print("🔐 AppDelegate AuthUIDelegate: Presenting ReCAPTCHA view controller")
    
    // Get the root view controller from the app's window
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController else {
      print("⚠️ Could not find root view controller")
      completion?()
      return
    }
    
    // Find the topmost view controller
    var topViewController = rootViewController
    while let presentedViewController = topViewController.presentedViewController {
      topViewController = presentedViewController
    }
    
    // If it's a SFSafariViewController, keep a reference to it
    if let safariVC = viewControllerToPresent as? SFSafariViewController {
      self.safariViewController = safariVC
      print("✅ SFSafariViewController reference saved - ReCAPTCHA will stay open")
      
      // Configure SafariViewController for better presentation
      safariVC.preferredControlTintColor = UIColor.systemBlue
      safariVC.modalPresentationStyle = .fullScreen
    }
    
    // Present the view controller
    topViewController.present(viewControllerToPresent, animated: flag) {
      print("✅ ReCAPTCHA view controller presented successfully")
      completion?()
    }
  }
  
  /// Dismiss ReCAPTCHA view controller
  func dismiss(animated flag: Bool, completion: (() -> Void)?) {
    print("🔐 AppDelegate AuthUIDelegate: Dismissing ReCAPTCHA view controller")
    
    // Find the topmost view controller
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController else {
      completion?()
      return
    }
    
    var topViewController = rootViewController
    while let presentedViewController = topViewController.presentedViewController {
      topViewController = presentedViewController
    }
    
    // Only dismiss if it's actually presenting something
    if topViewController.presentedViewController != nil {
      topViewController.dismiss(animated: flag) {
        print("✅ ReCAPTCHA view controller dismissed")
        self.safariViewController = nil
        completion?()
      }
    } else {
      completion?()
    }
  }
  
}
