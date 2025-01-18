//
//  AudioClassifier.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import SwiftUI
import AVFoundation
import SoundAnalysis
import CoreML

class AudioClassifier: NSObject, ObservableObject {
    static let shared = AudioClassifier()
    private let model: MusicGenreClassifier

    private let audioEngine = AVAudioEngine()
    private lazy var inputFormat: AVAudioFormat = {
        let inputNode = audioEngine.inputNode
        return inputNode.inputFormat(forBus: 0) // Fetch the input format directly from the input node
    }()
    
    // Track genre counts
    @Published private(set) var genreCount: [String: Int] = [:]

    private override init() {
        // Load the CoreML model
        do {
            self.model = try MusicGenreClassifier(configuration: MLModelConfiguration())
        } catch {
            fatalError("Failed to load CoreML model: \(error)")
        }

        super.init()

        // Configure the audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
        } catch {
            print("Audio session configuration failed: \(error)")
        }
    }

    func startListening(onResult: @escaping (String, Double) -> Void) {
        let confidenceThreshold: Double = 0.8 // 80% threshold

        let inputNode = audioEngine.inputNode

        inputNode.installTap(onBus: 0, bufferSize: 15600, format: inputFormat) { buffer, when in
            // Process the audio buffer
            let audioSamples = self.processAudioBuffer(buffer: buffer)
            
            // Perform prediction
            if let result = self.predictGenre(from: audioSamples) {
                if result.confidence >= confidenceThreshold {
                    DispatchQueue.main.async {
                        self.updateGenreCount(with: result.genre)
                        onResult(result.genre, result.confidence)
                    }
                } else {
                    DispatchQueue.main.async {
                        onResult("Uncertain Prediction", 0.0)
                    }
                }
            }
        }

        // Start the audio engine
        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Audio engine start error: \(error)")
        }
    }

    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        DispatchQueue.main.async {
            self.genreCount.removeAll() // Clear the genre count
        }
    }


    // Update genre count
    private func updateGenreCount(with genre: String) {
        genreCount[genre, default: 0] += 1
    }

    // Process the audio buffer into a Float32 MultiArray
    private func processAudioBuffer(buffer: AVAudioPCMBuffer) -> MLMultiArray? {
        guard let channelData = buffer.floatChannelData?[0] else {
            print("Failed to get channel data from buffer.")
            return nil
        }

        // Convert the audio buffer into a normalized MLMultiArray
        let frameCount = min(Int(buffer.frameLength), 15600)
        do {
            let audioSamples = try MLMultiArray(shape: [15600], dataType: .float32)
            for i in 0..<frameCount {
                audioSamples[i] = NSNumber(value: channelData[i])
            }
            return audioSamples
        } catch {
            print("Error creating MLMultiArray: \(error)")
            return nil
        }
    }

    // Perform prediction using the CoreML model
    private func predictGenre(from audioSamples: MLMultiArray?) -> (genre: String, confidence: Double)? {
        guard let audioSamples = audioSamples else { return nil }

        do {
            let prediction = try model.prediction(audioSamples: audioSamples)

            // Find the predicted genre and its confidence
            let genre = prediction.target
            let probabilities = prediction.targetProbability // "TargetProbability" is the confidence level of prediction
            if let confidence = probabilities[genre] {
                return (genre, confidence)
            } else {
                return (genre, 0.0) // Fallback if confidence is not found
            }
        } catch {
            print("Error during prediction: \(error)")
            return nil
        }
    }
}
