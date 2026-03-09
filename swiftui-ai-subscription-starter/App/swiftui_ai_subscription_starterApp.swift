//
//  swiftui_ai_subscription_starterApp.swift
//  swiftui-ai-subscription-starter
//
//  Created by Eugenio Barquin on 9/3/26.
//

import SwiftUI

@main
struct swiftui_ai_subscription_starterApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appState)
        }
    }
}
