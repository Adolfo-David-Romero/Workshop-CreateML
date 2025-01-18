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
    @ObservedObject private var classifier = AudioClassifier.shared // Observe genreCount updates

    var body: some View {
        VStack {
            Text("Live Genre Classification")
                .font(.largeTitle)
                .padding()
            
            Text(predictedGenre)
                .font(.title)
                .foregroundColor(predictedGenre == "Uncertain Prediction" ? .gray : .blue)
                .padding()
            
            if predictedGenre != "Uncertain Prediction" {
                Text(predictedConfidence)
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            Text("Top Genres:")
                .font(.headline)
                .padding(.top)
            
            // Display top 3 genres
            ForEach(topGenres, id: \.self) { genre in
                Text(genre)
                    .font(.body)
                    .padding(.vertical, 2)
            }

            Spacer()
            
            Button(action: {
                if isListening {
                    // Stop listening and reset state
                    classifier.stopListening()
                    predictedGenre = "Stopped listening."
                    predictedConfidence = ""
                } else {
                    // Start listening
                    predictedGenre = "Listening..."
                    predictedConfidence = ""
                    classifier.startListening { genre, confidence in
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

    // Get the top 3 genres
    private var topGenres: [String] {
        classifier.genreCount
            .sorted { $0.value > $1.value } // Sort by count
            .prefix(3) // Take top 3
            .map { "\($0.key): \($0.value)" } // Format as "Genre: Count"
    }
}



#Preview {
    PredictionView()
}
