//
//  PredictionView.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import SwiftUI

struct PredictionView: View {
    @State private var predictedGenre: String = "Press the button to start listening..."
    @State private var predictedConfidence: String = ""
    @State private var isListening: Bool = false // To track the state of the audio classification

    var body: some View {
        VStack {
            Text("Live Genre Classification")
                .font(.largeTitle)
                .padding()
            
            Text(predictedGenre)
                .font(.title)
                .foregroundColor(predictedGenre == "Uncertain Prediction" ? .gray : .blue) // Different color for uncertain predictions
                .padding()
            
            if predictedGenre != "Uncertain Prediction" {
                Text(predictedConfidence)
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                if isListening {
                    // Stop listening
                    AudioClassifier.shared.stopListening()
                    predictedGenre = "Stopped listening."
                    predictedConfidence = ""
                } else {
                    // Start listening
                    predictedGenre = "Listening..."
                    predictedConfidence = ""
                    AudioClassifier.shared.startListening { genre, confidence in
                        if confidence > 0.0 {
                            predictedGenre = genre
                            predictedConfidence = String(format: "Confidence: %.2f%%", confidence * 100)
                        } else {
                            predictedGenre = "Uncertain Prediction"
                            predictedConfidence = ""
                        }
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
