import SwiftUI
import Combine

enum AppRoute {
    case splash
    case onboarding
    case home
}

@MainActor
final class AppState: ObservableObject {
    @Published var route: AppRoute = .splash

    private let onboardingCompletedKey = "onboarding_completed"
    private let splashDuration: TimeInterval = 1.0

    init() {
        start()
    }

    private func start() {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(splashDuration * 1_000_000_000))
            route = isOnboardingCompleted ? .home : .onboarding
        }
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: onboardingCompletedKey)
        route = .home
    }

    private var isOnboardingCompleted: Bool {
        UserDefaults.standard.bool(forKey: onboardingCompletedKey)
    }
}
