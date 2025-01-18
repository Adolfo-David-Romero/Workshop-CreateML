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

    private var audioEngine = AVAudioEngine()
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private let inputFormat: AVAudioFormat
    private let queue = DispatchQueue(label: "AudioAnalysisQueue")
    private var resultsObserver: ResultsObserver?

    private override init() {
        self.inputFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        super.init()
    }

    func startListening(onResult: @escaping (String) -> Void) {
        let model: MLModel
        do {
            let compiledModelURL = try MLModel.compileModel(at: Bundle.main.url(forResource: "GenreClassifier", withExtension: "mlmodelc")!)
            model = try MLModel(contentsOf: compiledModelURL)
        } catch {
            print("Failed to load model: \(error)")
            return
        }

        resultsObserver = ResultsObserver(onResult: onResult)
        streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        streamAnalyzer?.add(MLModel: model, completionHandler: { error in //TODO: ADD MODEL
            if let error = error {
                print("Error adding MLModel: \(error)")
            }
        })

        let inputNode = audioEngine.inputNode

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { buffer, when in
            self.queue.async {
                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: when.sampleTime)
            }
        }

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
        streamAnalyzer = nil
    }
}

//MARK: - Result handeling

class ResultsObserver: NSObject, SNResultsObserving {
    private let onResult: (String) -> Void

    init(onResult: @escaping (String) -> Void) {
        self.onResult = onResult
    }

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classificationResult = result as? SNClassificationResult else {
            return
        }

        if let bestClassification = classificationResult.classifications.first {
            let genre = bestClassification.identifier
            self.onResult(genre)
        }
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Classification error: \(error)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("Request completed.")
    }
}
