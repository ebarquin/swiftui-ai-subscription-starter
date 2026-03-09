import Foundation

enum AnalyticsEvent: String {
    case onboardingStarted = "onboarding_started"
    case onboardingCompleted = "onboarding_completed"
    case insightRequested = "insight_requested"
    case insightGenerated = "insight_generated"
    case insightSaved = "insight_saved"
    case paywallViewed = "paywall_viewed"
    case subscribeTapped = "subscribe_tapped"
    case restoreTapped = "restore_tapped"
}

protocol AnalyticsServiceProtocol {
    func track(_ event: AnalyticsEvent, properties: [String: String]?)
}
