//
//  swiftui_ai_subscription_starterApp.swift
//  swiftui-ai-subscription-starter
//
//  Created by Eugenio Barquin on 9/3/26.
//

import SwiftUI

@main
struct swiftui_ai_subscription_starterApp: App {
    private let appEnvironment: AppEnvironment
    @StateObject private var appState: AppState

    init() {
        let environment = AppEnvironment.shared
        self.appEnvironment = environment
        _appState = StateObject(
            wrappedValue: AppState(analyticsService: environment.analyticsService)
        )
    }

    var body: some Scene {
        WindowGroup {
            AppRootView(appEnvironment: appEnvironment)
                .environmentObject(appState)
        }
    }
}
