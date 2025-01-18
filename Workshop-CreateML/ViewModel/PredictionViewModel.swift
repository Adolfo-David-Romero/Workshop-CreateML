//
//  PredictionViewModel.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//
import Foundation

class PredictionViewModel: ObservableObject {
    @Published var topGenres: [String] = []
    @Published var stickerURL: String? = nil
    @Published var predictedGenre: String = "Press the button to start listening..."
    @Published var predictedConfidence: String = ""
    @Published var isListening: Bool = false

    private var classifier = AudioClassifier.shared
    private var giphyManager = GiphyStickerManager()

    init() {
        bindGiphyManager()
    }

    private func bindGiphyManager() {
        giphyManager.$stickerURL.assign(to: &$stickerURL)
    }

    func startListening() {
        classifier.startListening { [weak self] genre, confidence in
            guard let self = self else { return }
            self.predictedGenre = genre
            self.predictedConfidence = String(format: "Confidence: %.2f%%", confidence * 100)

            let sortedGenres = self.classifier.genreCount.sorted { $0.value > $1.value }
            self.topGenres = sortedGenres.prefix(3).map { "\($0.key): \($0.value)" }

            if let topGenre = sortedGenres.first?.key {
                self.giphyManager.fetchSticker(for: topGenre)
            }
        }
        isListening = true
    }

    func stopListening() {
        classifier.stopListening()
        giphyManager.clearSticker()
        isListening = false
        predictedGenre = "Stopped listening."
        predictedConfidence = ""
        topGenres.removeAll()
    }
}
