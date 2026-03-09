import Foundation

enum SaveInsightOutcome {
    case saved(totalSaved: Int)
    case requiresPaywall(freeLimit: Int)
}

protocol SubscriptionServiceProtocol {
    var isPremium: Bool { get }
    var freeInsightLimit: Int { get }
    var savedInsightsCount: Int { get }

    func saveInsight(_ insight: Insight) -> SaveInsightOutcome
    func loadSavedInsights() -> [Insight]
    func subscribe()
    func restorePurchases()
}
