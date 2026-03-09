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
    private let analyticsService: AnalyticsServiceProtocol

    init(analyticsService: AnalyticsServiceProtocol = AppEnvironment.shared.analyticsService) {
        self.analyticsService = analyticsService
        start()
    }

    private func start() {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(splashDuration * 1_000_000_000))
            route = isOnboardingCompleted ? .home : .onboarding
            if case .onboarding = route {
                analyticsService.track(.onboardingStarted, properties: nil)
            }
        }
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: onboardingCompletedKey)
        route = .home
        analyticsService.track(.onboardingCompleted, properties: nil)
    }

    private var isOnboardingCompleted: Bool {
        UserDefaults.standard.bool(forKey: onboardingCompletedKey)
    }
}
