import SwiftUI

struct PaywallView: View {
    let onSubscribe: () -> Void
    let onRestore: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Go Premium")
                    .font(.title2.weight(.bold))

                Text("Unlock unlimited saved insights and keep all your wellness reflections in one place.")
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Label("Unlimited saved insights", systemImage: "checkmark.circle.fill")
                    Label("No free-tier save limit", systemImage: "checkmark.circle.fill")
                    Label("Ready for real purchases later", systemImage: "checkmark.circle.fill")
                }
                .font(.subheadline)

                Spacer()

                Button("Subscribe") {
                    onSubscribe()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)

                Button("Restore") {
                    onRestore()
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        onDismiss()
                    }
                }
            }
        }
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(onSubscribe: {}, onRestore: {}, onDismiss: {})
    }
}
