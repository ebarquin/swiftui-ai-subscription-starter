import Foundation

struct MockAnalyticsService: AnalyticsServiceProtocol {
    func track(_ event: AnalyticsEvent, properties: [String: String]? = nil) {
        let details = properties ?? [:]
        print("[MockAnalytics] \(event.rawValue) \(details)")
    }
}
