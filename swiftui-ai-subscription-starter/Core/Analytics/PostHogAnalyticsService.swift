import Foundation

struct PostHogAnalyticsService: AnalyticsServiceProtocol {
    func track(_ event: AnalyticsEvent, properties: [String: String]? = nil) {
        // Placeholder for future PostHog SDK integration.
        // Example:
        // PostHogSDK.shared.capture(event: event.rawValue, properties: properties)
        print("[PostHogPlaceholder] \(event.rawValue) \(properties ?? [:])")
    }
}
