import Foundation

struct SubscriptionGate {
    let freeInsightLimit: Int

    init(freeInsightLimit: Int = 2) {
        self.freeInsightLimit = freeInsightLimit
    }

    func outcomeForNextSave(isPremium: Bool, currentSavedCount: Int) -> SaveInsightOutcome {
        guard isPremium || currentSavedCount < freeInsightLimit else {
            return .requiresPaywall(freeLimit: freeInsightLimit)
        }
        return .saved(totalSaved: currentSavedCount + 1)
    }
}
