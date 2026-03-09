import Foundation
import Combine

@MainActor
final class InsightResultViewModel: ObservableObject {
    @Published var showPaywall = false
    @Published var saveMessage: String?
    @Published var isPremium = false
    @Published var savedCount = 0

    let insight: Insight

    private let subscriptionService: SubscriptionServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol

    init(
        insight: Insight,
        subscriptionService: SubscriptionServiceProtocol = AppEnvironment.shared.subscriptionService,
        analyticsService: AnalyticsServiceProtocol = AppEnvironment.shared.analyticsService
    ) {
        self.insight = insight
        self.subscriptionService = subscriptionService
        self.analyticsService = analyticsService
        refreshState()
    }

    func saveInsight() {
        switch subscriptionService.saveInsight(insight) {
        case .saved(let totalSaved):
            savedCount = totalSaved
            saveMessage = "Insight saved successfully."
            showPaywall = false
            analyticsService.track(.insightSaved, properties: nil)
        case .requiresPaywall(let freeLimit):
            saveMessage = "Free plan reached (\(freeLimit) insights). Upgrade to save more."
            showPaywall = true
            analyticsService.track(.paywallViewed, properties: nil)
        }
    }

    func subscribe() {
        analyticsService.track(.subscribeTapped, properties: nil)
        subscriptionService.subscribe()
        refreshState()
        saveInsight()
    }

    func restore() {
        analyticsService.track(.restoreTapped, properties: nil)
        subscriptionService.restorePurchases()
        refreshState()
        saveInsight()
    }

    private func refreshState() {
        isPremium = subscriptionService.isPremium
        savedCount = subscriptionService.savedInsightsCount
    }
}
