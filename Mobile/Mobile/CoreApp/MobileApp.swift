import SwiftUI
import Firebase
import GoogleSignIn
import UIKit

@main
struct MobileApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isCareMode") private var isOlderMode = false
    @StateObject private var cartManager = CartManager()
    @StateObject private var authViewModel = AuthenticationView()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.fontSizeMultiplier, isOlderMode ? 1.25 : 1.0)
                .environmentObject(cartManager)
                .environmentObject(authViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
