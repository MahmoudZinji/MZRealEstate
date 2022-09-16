//
//  RealEstateApp.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-06.
//

import SwiftUI
import Firebase

@main
struct RealEstateApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var firebaseUserManager = FirebaseUserManager()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(firebaseUserManager)
        }
    }
}

// MARK: -AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}
