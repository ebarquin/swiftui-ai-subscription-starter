import Foundation

final class AppEnvironment {
    static let shared = AppEnvironment()

    let analyticsService: AnalyticsServiceProtocol
    let aiService: AIServiceProtocol
    let subscriptionService: SubscriptionServiceProtocol

    init(
        analyticsService: AnalyticsServiceProtocol = MockAnalyticsService(),
        aiService: AIServiceProtocol = MockAIService(),
        subscriptionService: SubscriptionServiceProtocol = MockSubscriptionService()
    ) {
        self.analyticsService = analyticsService
        self.aiService = aiService
        self.subscriptionService = subscriptionService
    }
}
