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


    func startListening(onResult: @escaping (String) -> Void) {
        let inputNode = audioEngine.inputNode

        inputNode.installTap(onBus: 0, bufferSize: 15600, format: inputFormat) { buffer, when in
            // Process the audio buffer
            let audioSamples = self.processAudioBuffer(buffer: buffer)
            
            // Perform prediction
            if let prediction = self.predictGenre(from: audioSamples) {
                DispatchQueue.main.async {
                    onResult(prediction)
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
    private func predictGenre(from audioSamples: MLMultiArray?) -> String? {
        guard let audioSamples = audioSamples else { return nil }

        do {
            let prediction = try model.prediction(audioSamples: audioSamples)
            return prediction.target //"Target" is the genre
        } catch {
            print("Error during prediction: \(error)")
            return nil
        }
    }
}

