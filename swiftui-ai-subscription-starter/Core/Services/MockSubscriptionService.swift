import Foundation

protocol KeyValueStoring {
    func data(forKey defaultName: String) -> Data?
    func bool(forKey defaultName: String) -> Bool
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: KeyValueStoring {}

final class MockSubscriptionService: SubscriptionServiceProtocol {
    private let store: KeyValueStoring
    private let savedInsightsKey = "saved_insights"
    private let premiumKey = "is_premium_user"

    let freeInsightLimit: Int = 2
    private let gate: SubscriptionGate

    init(defaults: UserDefaults = .standard) {
        self.store = defaults
        self.gate = SubscriptionGate()
    }

    init(store: KeyValueStoring) {
        self.store = store
        self.gate = SubscriptionGate()
    }

    var isPremium: Bool {
        store.bool(forKey: premiumKey)
    }

    var savedInsightsCount: Int {
        loadSavedInsights().count
    }

    func saveInsight(_ insight: Insight) -> SaveInsightOutcome {
        let currentInsights = loadSavedInsights()
        let outcome = gate.outcomeForNextSave(
            isPremium: isPremium,
            currentSavedCount: currentInsights.count
        )

        guard case .saved = outcome else {
            return outcome
        }

        var updatedInsights = currentInsights
        updatedInsights.append(insight)
        persistInsights(updatedInsights)

        return outcome
    }

    func loadSavedInsights() -> [Insight] {
        guard let data = store.data(forKey: savedInsightsKey) else {
            return []
        }
        return (try? JSONDecoder().decode([Insight].self, from: data)) ?? []
    }

    func subscribe() {
        store.set(true, forKey: premiumKey)
    }

    func restorePurchases() {
        // Mock behavior: restore sets premium as active.
        store.set(true, forKey: premiumKey)
    }

    private func persistInsights(_ insights: [Insight]) {
        guard let data = try? JSONEncoder().encode(insights) else {
            return
        }
        store.set(data, forKey: savedInsightsKey)
    }
}
