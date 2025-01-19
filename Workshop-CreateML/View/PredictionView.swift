//
//  PredictionView.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import SwiftUI

struct PredictionView: View {
    @StateObject private var viewModel = PredictionViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                VStack {
                    Text("Live Genre Classification")
                        .font(.largeTitle)
                        .padding()
                    
                    Text(viewModel.predictedGenre)
                        .font(.title)
                        .foregroundColor(viewModel.predictedGenre == "Uncertain Prediction" ? .gray : .blue)
                        .padding()
                    
                    if viewModel.predictedGenre != "Uncertain Prediction" {
                        Text(viewModel.predictedConfidence)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("Top Genres:")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(viewModel.topGenres, id: \.self) { genre in
                        Text(genre)
                            .font(.body)
                            .padding(.vertical, 2)
                    }
                    
                    Spacer()
                    
                    if let stickerURL = viewModel.stickerURL {
                        AsyncImage(url: URL(string: stickerURL)) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFit().frame(maxWidth: 200, maxHeight: 200)
                            } else if phase.error != nil {
                                Text("Failed to load sticker").foregroundColor(.red)
                            } else {
                                ProgressView()
                            }
                        }
                        .padding()
                    }
                    
                    Button(action: {
                        if viewModel.isListening {
                            viewModel.stopListening()
                        } else {
                            viewModel.startListening()
                        }
                    }) {
                        Label(viewModel.isListening ? "Stop" : "Start", systemImage: viewModel.isListening ? "stop.circle" : "microphone.circle")
                            .font(.largeTitle)
                    }
                    .padding()
                    .foregroundColor(viewModel.isListening ? .red : .blue)
                }
                .padding()
            }
        }
    }
}



#Preview {
    PredictionView()
}
