//
//  swiftui_ai_subscription_starterTests.swift
//  swiftui-ai-subscription-starterTests
//
//  Created by Eugenio Barquin on 9/3/26.
//

import XCTest
@testable import swiftui_ai_subscription_starter

final class swiftui_ai_subscription_starterTests: XCTestCase {
    func testOnboardingCompletionPersistsFlagAndIsReadOnLaunch() async throws {
        let analytics = InMemoryAnalyticsService()
        let store = InMemoryKeyValueStore()
        let key = "onboarding_completed"

        let firstLaunchState = await MainActor.run {
            AppState(
                analyticsService: analytics,
                store: store,
                splashDuration: 0
            )
        }

        await MainActor.run {
            firstLaunchState.completeOnboarding()
        }

        XCTAssertTrue(store.bool(forKey: key))

        let secondLaunchState = await MainActor.run {
            AppState(
                analyticsService: analytics,
                store: store,
                splashDuration: 0
            )
        }

        let route = await waitForRoute(
            in: secondLaunchState,
            expected: .home,
            timeout: 1.0
        )
        XCTAssertEqual(route, .home)
    }

    func testFreeUsersCanSaveTwoInsightsAndThirdTriggersPaywall() throws {
        let gate = SubscriptionGate(freeInsightLimit: 2)
        let first = gate.outcomeForNextSave(isPremium: false, currentSavedCount: 0)
        let second = gate.outcomeForNextSave(isPremium: false, currentSavedCount: 1)
        let third = gate.outcomeForNextSave(isPremium: false, currentSavedCount: 2)

        guard case .saved(let count1) = first else {
            return XCTFail("Expected first save to succeed")
        }
        guard case .saved(let count2) = second else {
            return XCTFail("Expected second save to succeed")
        }
        guard case .requiresPaywall(let limit) = third else {
            return XCTFail("Expected third save to require paywall")
        }

        XCTAssertEqual(count1, 1)
        XCTAssertEqual(count2, 2)
        XCTAssertEqual(limit, 2)
    }

    func testPremiumUsersCanSaveWithoutLimit() throws {
        let gate = SubscriptionGate(freeInsightLimit: 2)

        for index in 1...5 {
            let result = gate.outcomeForNextSave(isPremium: true, currentSavedCount: index - 1)
            guard case .saved(let totalSaved) = result else {
                return XCTFail("Expected premium save to succeed at index \(index)")
            }
            XCTAssertEqual(totalSaved, index)
        }
    }

    func testInsightModelCodableRoundTrip() throws {
        let insight = makeInsight(index: 7)

        let data = try JSONEncoder().encode(insight)
        let decoded = try JSONDecoder().decode(Insight.self, from: data)

        XCTAssertEqual(decoded, insight)
    }

    func testMockAIServiceGeneratesDeterministicStructuredOutput() throws {
        let service = MockAIService()
        let input = "I feel stressed at work and my sleep has been inconsistent"

        let first = service.generateInsight(from: input)
        let second = service.generateInsight(from: input)

        XCTAssertEqual(first.title, second.title)
        XCTAssertEqual(first.summary, second.summary)
        XCTAssertEqual(first.actionItems, second.actionItems)
        XCTAssertEqual(first.tone, second.tone)
        XCTAssertEqual(first.disclaimer, second.disclaimer)
        XCTAssertEqual(first.actionItems.count, 3)
        XCTAssertTrue(first.title.contains("Sleep Quality"))
    }

    private func makeInsight(index: Int) -> Insight {
        Insight(
            id: UUID(),
            title: "Insight \(index)",
            summary: "Summary \(index)",
            actionItems: ["Action A", "Action B", "Action C"],
            tone: "Balanced",
            disclaimer: "Mock disclaimer",
            createdAt: Date(timeIntervalSince1970: TimeInterval(index))
        )
    }

    private func waitForRoute(
        in appState: AppState,
        expected: AppRoute,
        timeout: TimeInterval
    ) async -> AppRoute {
        let deadline = Date().addingTimeInterval(timeout)
        var current = await MainActor.run { appState.route }

        while current != expected && Date() < deadline {
            try? await Task.sleep(nanoseconds: 20_000_000)
            current = await MainActor.run { appState.route }
        }

        return current
    }
}

private final class InMemoryAnalyticsService: AnalyticsServiceProtocol {
    private(set) var capturedEvents: [AnalyticsEvent] = []

    func track(_ event: AnalyticsEvent, properties: [String: String]?) {
        capturedEvents.append(event)
    }
}

private final class InMemoryKeyValueStore: KeyValueStoring {
    private var values: [String: Any] = [:]

    func data(forKey defaultName: String) -> Data? {
        values[defaultName] as? Data
    }

    func bool(forKey defaultName: String) -> Bool {
        values[defaultName] as? Bool ?? false
    }

    func set(_ value: Any?, forKey defaultName: String) {
        values[defaultName] = value
    }
}
