import Foundation

struct Insight: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let summary: String
    let actionItems: [String]
    let tone: String
    let disclaimer: String
    let createdAt: Date
}
