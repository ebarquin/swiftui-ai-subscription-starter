import Foundation

struct Insight: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    let actionItems: [String]
    let tone: String
    let disclaimer: String
    let createdAt: Date
}
