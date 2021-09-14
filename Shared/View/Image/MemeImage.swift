//
//  MemeImage.swift
//  MemeImage
//
//  Created by Brent Mifsud on 2021-09-14.
//

import SwiftUI
import os

struct MemeImage: View {
    private class MemeCache {
        private lazy var cache = [URL: Image]()

        func set(image: Image, for url: URL) {
            cache[url] = image
        }

        func getImage(for url: URL) -> Image? {
            cache[url]
        }

        func clearCache() {
            cache = [:]
        }
    }

    private static let cache = MemeCache()

    var url: URL?

    var body: some View {
        if let url = url,
            let image = Self.cache.getImage(for: url) {
            image.resizable()
        } else {
            AsyncImage(
                url: url,
                scale: 1.0,
                transaction: Transaction(animation: .easeOut(duration: 0.2))
            ) { phase in
                switch phase {
                case .empty:
                    Color.secondary
                        .overlay(ProgressView().progressViewStyle(.circular))
                case let .success(image):
                    cacheAndReturnImage(image: image)
                        .resizable()
                        .transition(.opacity)
                case .failure:
                    Image("meme-not-found")
                        .resizable()
                        .transition(.opacity)
                @unknown default:
                    Image("meme-not-found")
                        .resizable()
                }
            }
        }
    }

    private func cacheAndReturnImage(image: Image) -> Image {
        guard let url = url else { return image }
        Self.cache.set(image: image, for: url)
        return image
    }
}

struct MemeImage_Previews: PreviewProvider {
    static var previews: some View {
        MemeImage()
    }
}
