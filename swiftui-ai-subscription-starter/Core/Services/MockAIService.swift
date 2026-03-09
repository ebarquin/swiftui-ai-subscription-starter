import Foundation

struct MockAIService: AIServiceProtocol {
    func generateInsight(from input: String) -> Insight {
        let cleanedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let lowered = cleanedInput.lowercased()

        let tone = inferTone(from: lowered)
        let focus = inferFocus(from: lowered)
        let title = buildTitle(from: cleanedInput, focus: focus)
        let summary = buildSummary(from: cleanedInput, tone: tone, focus: focus)
        let actionItems = buildActionItems(from: lowered, focus: focus)

        return Insight(
            id: UUID(),
            title: title,
            summary: summary,
            actionItems: actionItems,
            tone: tone,
            disclaimer: "This is a mock wellness insight and not medical advice.",
            createdAt: Date()
        )
    }

    private func inferTone(from input: String) -> String {
        let stressWords = ["stress", "anxious", "overwhelmed", "tired", "burnout", "worried", "sad"]
        let positiveWords = ["good", "great", "energized", "calm", "motivated", "focused", "happy"]

        let stressScore = stressWords.filter { input.contains($0) }.count
        let positiveScore = positiveWords.filter { input.contains($0) }.count

        if stressScore > positiveScore {
            return "Supportive and grounding"
        } else if positiveScore > stressScore {
            return "Encouraging and momentum-focused"
        } else {
            return "Balanced and practical"
        }
    }

    private func inferFocus(from input: String) -> String {
        if input.contains("sleep") {
            return "sleep quality"
        }
        if input.contains("work") || input.contains("deadline") {
            return "workload balance"
        }
        if input.contains("exercise") || input.contains("workout") || input.contains("run") {
            return "physical consistency"
        }
        if input.contains("eat") || input.contains("meal") || input.contains("food") {
            return "daily nutrition rhythm"
        }
        return "daily wellbeing"
    }

    private func buildTitle(from input: String, focus: String) -> String {
        let words = input
            .split(separator: " ")
            .map(String.init)
            .filter { !$0.isEmpty }
        let snippet = words.prefix(4).joined(separator: " ")

        if snippet.isEmpty {
            return "Wellness Insight"
        }
        return "\(focus.capitalized): \(snippet)"
    }

    private func buildSummary(from input: String, tone: String, focus: String) -> String {
        "Based on what you shared (\(input)), your current pattern suggests an opportunity to improve \(focus). The recommended next step is a small, repeatable adjustment that keeps your routine realistic and aligned with a \(tone.lowercased()) approach."
    }

    private func buildActionItems(from input: String, focus: String) -> [String] {
        var items: [String] = []

        switch focus {
        case "sleep quality":
            items.append("Set a fixed wind-down time tonight, even if only 20 minutes before bed.")
            items.append("Reduce screen stimulation in the last hour before sleep.")
        case "workload balance":
            items.append("Pick one high-impact task and protect a 25-minute focus block for it.")
            items.append("Define a hard stop time for work today to avoid spillover stress.")
        case "physical consistency":
            items.append("Schedule a short movement block (10-20 minutes) at a specific time.")
            items.append("Prepare one easy backup workout for low-energy days.")
        case "daily nutrition rhythm":
            items.append("Plan your next meal in advance to reduce impulsive choices.")
            items.append("Anchor one meal with protein and hydration.")
        default:
            items.append("Choose one simple self-care action you can complete in under 10 minutes.")
            items.append("Set one clear priority for today and defer nonessential tasks.")
        }

        if input.contains("stress") || input.contains("anxious") || input.contains("overwhelmed") {
            items.append("Take two 60-second breathing pauses during your day.")
        } else if input.contains("tired") || input.contains("low energy") {
            items.append("Use a short walk or stretch break to reset your energy midday.")
        } else {
            items.append("End the day with a quick reflection: what helped and what to adjust tomorrow.")
        }

        return Array(items.prefix(3))
    }
}
