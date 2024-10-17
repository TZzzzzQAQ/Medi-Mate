//
//  GoogleSignInFireBase.swift
//  Mobile
//
//  Created by Lykheang Taing on 06/08/2024.
//

//import Foundation
//import SwiftUI
//import Firebase
//import GoogleSignIn
//import UIKit  // This import is necessary for UIApplicationDelegate and other UIKit components
//
//@main
//struct GoogleSigninFirebaseApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
//}
//
