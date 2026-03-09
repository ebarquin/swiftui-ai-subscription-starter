//
//  ContentView.swift
//  swiftui-ai-subscription-starter
//
//  Created by Eugenio Barquin on 9/3/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("How are you feeling today?")
                    .font(.title3.weight(.semibold))

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.inputText)
                        .frame(minHeight: 120)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    if viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("Write a short note about your day...")
                            .foregroundStyle(.tertiary)
                            .padding(.top, 16)
                            .padding(.leading, 14)
                            .allowsHitTesting(false)
                    }
                }

                Button("Generate Insight") {
                    viewModel.generateInsight()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isInputValid)

                if !viewModel.isInputValid {
                    Text("Please enter some text before generating.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
            .navigationDestination(item: $viewModel.generatedInsight) { insight in
                InsightResultView(insight: insight)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
