import SwiftUI

struct AppRootView: View {
    let appEnvironment: AppEnvironment

    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            switch appState.route {
            case .splash:
                SplashView()
            case .onboarding:
                OnboardingView {
                    appState.completeOnboarding()
                }
            case .home:
                HomeView(
                    aiService: appEnvironment.aiService,
                    analyticsService: appEnvironment.analyticsService,
                    subscriptionService: appEnvironment.subscriptionService
                )
            }
        }
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView(appEnvironment: AppEnvironment.shared)
            .environmentObject(AppState())
    }
}
