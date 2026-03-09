import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var generatedInsight: Insight?

    private let aiService: AIServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol

    init(
        aiService: AIServiceProtocol = AppEnvironment.shared.aiService,
        analyticsService: AnalyticsServiceProtocol = AppEnvironment.shared.analyticsService
    ) {
        self.aiService = aiService
        self.analyticsService = analyticsService
    }

    var isInputValid: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func generateInsight() {
        guard isInputValid else { return }
        analyticsService.track(.insightRequested, properties: nil)
        generatedInsight = aiService.generateInsight(from: inputText)
        analyticsService.track(.insightGenerated, properties: nil)
    }
}
