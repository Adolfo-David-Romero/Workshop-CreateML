//
//  GiphyStickerView.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import SwiftUI

struct GiphyStickerComponentView: View {
    @State private var stickerURL: String? = nil
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            Text("Giphy Sticker")
                .font(.title)
                .padding()

            if let stickerURL = stickerURL {
                AsyncImage(url: URL(string: stickerURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 200)
                    } else if phase.error != nil {
                        Text("Failed to load sticker")
                            .foregroundColor(.red)
                    } else {
                        ProgressView()
                    }
                }
                .padding()
            } else if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
        }
        .onAppear(perform: fetchSticker)
    }

    func fetchSticker() {
        guard let url = URL(string: "https://api.giphy.com/v1/stickers/search?api_key=0vRJcBT7nzox8xlqDFGPV1N9cLkLzwAj&q=Jazz&limit=25&offset=0&rating=g&lang=en&bundle=messaging_non_clips") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch sticker: \(error.localizedDescription)"
                    isLoading = false
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    isLoading = false
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let dataArray = json["data"] as? [[String: Any]],
                   let firstSticker = dataArray.first,
                   let images = firstSticker["images"] as? [String: Any],
                   let fixedHeight = images["fixed_height"] as? [String: Any],
                   let urlString = fixedHeight["url"] as? String {
                    DispatchQueue.main.async {
                        stickerURL = urlString
                        isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = "Failed to parse sticker URL"
                        isLoading = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Error parsing response: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }.resume()
    }
}


#Preview {
    GiphyStickerComponentView()
}
