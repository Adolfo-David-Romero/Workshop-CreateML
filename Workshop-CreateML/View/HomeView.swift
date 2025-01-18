//
//  HomeView.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackgroundView(colors: GradientColors.all)
                VStack {
                    TitleComponentView()
                        .foregroundStyle(.white)
                        .blendMode(.difference)
                        .overlay(TitleComponentView().blendMode(.hue))
                        .overlay(TitleComponentView().foregroundStyle(.black).blendMode(.overlay))

                    Spacer()

                    NavigationLink {
                        PredictionView()
                    } label: {
                        HStack(alignment: .center, spacing: 13.0) {
                            Text("ENTER")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                        .background(Color(.systemBlue))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 50)

                    Image("pointing-soyjack")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .background(GradientColors.backgroundColor)
    }
}
#Preview {
    HomeView()
}
