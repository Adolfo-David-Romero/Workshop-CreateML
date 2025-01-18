//
//  GiphyStickerManager.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import Foundation

class GiphyStickerManager: ObservableObject {
    @Published var stickerURL: String? = nil
    private let apiKey = "0vRJcBT7nzox8xlqDFGPV1N9cLkLzwAj"

    func fetchSticker(for genre: String) {
        guard !genre.isEmpty else { return }
        let urlString = "https://api.giphy.com/v1/stickers/search?api_key=\(apiKey)&q=\(genre)&limit=1&offset=0&rating=g&lang=en&bundle=messaging_non_clips"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let dataArray = json["data"] as? [[String: Any]],
               let firstSticker = dataArray.first,
               let images = firstSticker["images"] as? [String: Any],
               let fixedHeight = images["fixed_height"] as? [String: Any],
               let urlString = fixedHeight["url"] as? String {
                DispatchQueue.main.async {
                    self.stickerURL = urlString
                }
            }
        }.resume()
    }

    func clearSticker() {
        DispatchQueue.main.async { self.stickerURL = nil }
    }
}
