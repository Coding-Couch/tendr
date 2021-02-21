//
//  ImageLoader.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI
import Combine
import Foundation

import Combine
import SwiftUI

/// `ObservableObject` that loads and publishes a single image asynchronously.
class ImageLoader: ObservableObject {
	#if os(iOS) || os(watchOS) || os(tvOS)
	@Published var image: UIImage?
	#elseif os(macOS)
	@Published var image: NSImage?
	#endif
	@Published var loading: Bool = false
	@Published var url: URL

	private let cache = ImageCache.shared
	private var cancellable: AnyCancellable?

	init(url: URL) {
		self.url = url
	}

	deinit {
		cancel()
	}

	/// Load the image from the specified url.
	func load() {
		cancellable?.cancel()
		cancellable = nil

		loading = true

		if let cacheImage = ImageCache.shared.get(forKey: url.absoluteString) {
			image = cacheImage
			loading = false
			return
		}

		cancellable = URLSession.shared.dataTaskPublisher(for: url)
			.map { data, urlResponse in
				if let urlResponse = urlResponse as? HTTPURLResponse,
				   let status = urlResponse.status, status == .notFound {
					#if os(iOS) || os(watchOS) || os(tvOS)
					return UIImage(named: "meme-not-found")
					#elseif os(macOS)
					return NSImage(named: "meme-not-found")
					#endif
				}
				
				
				#if os(iOS) || os(watchOS) || os(tvOS)
				return UIImage(data: data)
				#elseif os(macOS)
				return NSImage(data: data)
				#endif
			}
			.replaceError(with: {
				#if os(iOS) || os(watchOS) || os(tvOS)
				return UIImage(named: "meme-not-found")
				#elseif os(macOS)
				return NSImage(named: "meme-not-found")
				#endif
			}())
			.receive(on: RunLoop.main)
			.handleEvents(
				receiveOutput: { [cache, url] image in
					guard let image = image else { return }
					
					cache.set(forKey: url.absoluteString, image: image)
				},
				receiveCompletion: { [weak self] _ in
					self?.loading = false
				},
				receiveCancel: { [weak self] in
					self?.loading = false
				}
			)
			.assign(to: \.image, on: self)
	}

	/// Cancel loading in progress.
	func cancel() {
		cancellable?.cancel()
		cancellable = nil
	}
}
