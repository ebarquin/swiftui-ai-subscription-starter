import Foundation

protocol AIServiceProtocol {
    func generateInsight(from input: String) -> Insight
}
