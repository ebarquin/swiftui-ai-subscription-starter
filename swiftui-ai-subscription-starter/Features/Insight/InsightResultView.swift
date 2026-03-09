import SwiftUI

struct InsightResultView: View {
    let insight: Insight

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(insight.title)
                    .font(.title2.weight(.bold))

                Text(insight.summary)
                    .font(.body)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Action Items")
                        .font(.headline)
                    ForEach(Array(insight.actionItems.prefix(3).enumerated()), id: \.offset) { index, item in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1).")
                                .font(.subheadline.weight(.semibold))
                            Text(item)
                                .font(.subheadline)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Tone")
                        .font(.headline)
                    Text(insight.tone)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(insight.disclaimer)
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Your Insight")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InsightResultView_Previews: PreviewProvider {
    static var previews: some View {
        InsightResultView(
            insight: Insight(
                id: UUID(),
                title: "Daily Wellbeing: Feeling tired lately",
                summary: "You may benefit from a smaller, repeatable reset in your routine.",
                actionItems: [
                    "Set a short evening wind-down routine.",
                    "Protect one focused morning block.",
                    "Take two breathing pauses during the day."
                ],
                tone: "Supportive and grounding",
                disclaimer: "This is a mock wellness insight and not medical advice.",
                createdAt: Date()
            )
        )
    }
}
