import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var generatedInsight: Insight?

    private let aiService: AIServiceProtocol = MockAIService()

    var isInputValid: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func generateInsight() {
        guard isInputValid else { return }
        generatedInsight = aiService.generateInsight(from: inputText)
    }
}
