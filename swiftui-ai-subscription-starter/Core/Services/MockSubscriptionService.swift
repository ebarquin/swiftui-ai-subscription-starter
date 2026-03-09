import Foundation

final class MockSubscriptionService: SubscriptionServiceProtocol {
    private let defaults: UserDefaults
    private let savedInsightsKey = "saved_insights"
    private let premiumKey = "is_premium_user"

    let freeInsightLimit: Int = 2

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isPremium: Bool {
        defaults.bool(forKey: premiumKey)
    }

    var savedInsightsCount: Int {
        loadSavedInsights().count
    }

    func saveInsight(_ insight: Insight) -> SaveInsightOutcome {
        let currentInsights = loadSavedInsights()

        guard isPremium || currentInsights.count < freeInsightLimit else {
            return .requiresPaywall(freeLimit: freeInsightLimit)
        }

        var updatedInsights = currentInsights
        updatedInsights.append(insight)
        persistInsights(updatedInsights)

        return .saved(totalSaved: updatedInsights.count)
    }

    func loadSavedInsights() -> [Insight] {
        guard let data = defaults.data(forKey: savedInsightsKey) else {
            return []
        }
        return (try? JSONDecoder().decode([Insight].self, from: data)) ?? []
    }

    func subscribe() {
        defaults.set(true, forKey: premiumKey)
    }

    func restorePurchases() {
        // Mock behavior: restore sets premium as active.
        defaults.set(true, forKey: premiumKey)
    }

    private func persistInsights(_ insights: [Insight]) {
        guard let data = try? JSONEncoder().encode(insights) else {
            return
        }
        defaults.set(data, forKey: savedInsightsKey)
    }
}
