//
//  PredictionView.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import SwiftUI

struct PredictionView: View {
    @State private var predictedGenre: String = "Press the button to start listening..."
    @State private var isListening: Bool = false // To track the state of the audio classification

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
            
            Button(action: {
                if isListening {
                    // Stop listening
                    AudioClassifier.shared.stopListening()
                    predictedGenre = "Stopped listening."
                } else {
                    // Start listening
                    predictedGenre = "Listening..."
                    AudioClassifier.shared.startListening { genre in
                        predictedGenre = genre
                    }
                }
                isListening.toggle()
            }, label: {
                Label(isListening ? "Stop" : "Start", systemImage: isListening ? "stop.circle" : "microphone.circle")
                    .font(.largeTitle)
            })
            .padding()
            .foregroundColor(isListening ? .red : .blue)
        }
        .padding()
    }
}

#Preview {
    PredictionView()
}
