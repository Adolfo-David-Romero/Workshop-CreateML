//
//  PredictionView.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import SwiftUI

struct PredictionView: View {
    @State private var predictedGenre: String = "Listening..."
    var body: some View {
        VStack {
            Text("Live Genre Classification")
                .font(.largeTitle)
                .padding()
                            

            Text(predictedGenre)
                .font(.title)
                .foregroundColor(.blue)
                .padding()

            Spacer()
                            
        }
        .padding()
    }
}

#Preview {
    PredictionView()
}
