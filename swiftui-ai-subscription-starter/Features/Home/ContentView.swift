//
//  ContentView.swift
//  swiftui-ai-subscription-starter
//
//  Created by Eugenio Barquin on 9/3/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "house.fill")
                .font(.system(size: 36))
                .foregroundStyle(.primary)
            Text("Home")
                .font(.title2.weight(.semibold))
            Text("You are ready to start building.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
