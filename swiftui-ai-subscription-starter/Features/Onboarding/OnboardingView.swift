import SwiftUI

private struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let symbolName: String
}

struct OnboardingView: View {
    let onComplete: () -> Void

    @State private var currentPageIndex = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome",
            message: "Track your goals and stay consistent with a clean daily workflow.",
            symbolName: "star"
        ),
        OnboardingPage(
            title: "Build Habits",
            message: "Use simple reminders and focused actions to move forward every day.",
            symbolName: "checkmark.circle"
        ),
        OnboardingPage(
            title: "Stay Organized",
            message: "Keep your progress in one place and focus on what matters most.",
            symbolName: "list.bullet.rectangle"
        )
    ]

    private var isLastPage: Bool {
        currentPageIndex == pages.count - 1
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            TabView(selection: $currentPageIndex) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    pageContent(page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack(spacing: 20) {
                pageIndicator
                Button(action: continueTapped) {
                    Text(isLastPage ? "Get Started" : "Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
        .background(Color(.systemBackground))
    }

    private var topBar: some View {
        HStack {
            Spacer()
            Button("Skip", action: onComplete)
                .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }

    private func pageContent(_ page: OnboardingPage) -> some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: page.symbolName)
                .font(.system(size: 56))
                .foregroundStyle(.primary)
            Text(page.title)
                .font(.title.weight(.bold))
            Text(page.message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(pages.indices, id: \.self) { index in
                Capsule()
                    .fill(index == currentPageIndex ? Color.primary : Color.secondary.opacity(0.25))
                    .frame(width: index == currentPageIndex ? 22 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPageIndex)
            }
        }
    }

    private func continueTapped() {
        if isLastPage {
            onComplete()
            return
        }
        currentPageIndex += 1
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onComplete: {})
    }
}
