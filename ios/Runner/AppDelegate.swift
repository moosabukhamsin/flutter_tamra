import UIKit
import Flutter
// Firebase initialization is handled in Flutter (main.dart)
// Don't call FirebaseApp.configure() here to avoid duplicate initialization

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase is initialized in Flutter main.dart via Firebase.initializeApp()
    // Calling FirebaseApp.configure() here causes duplicate initialization issues
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
