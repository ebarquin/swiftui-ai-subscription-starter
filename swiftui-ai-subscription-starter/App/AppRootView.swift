import SwiftUI

struct AppRootView: View {
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
                HomeView()
            }
        }
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
            .environmentObject(AppState())
    }
}
