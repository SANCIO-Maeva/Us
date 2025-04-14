//
//  UsApp.swift
//  Us
//
//  Created by Maëva SANCIO on 26/02/2025.
//

import SwiftUI

@main
struct UsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        WindowGroup {
            HomeView()
        }
        WindowGroup {
            SignUpView()
        }
        WindowGroup {
            ForgotPassword()
        }
        WindowGroup {
            AnnouncementsView()
        }
        WindowGroup {
            DiscussionsView()
        }
    }
}
