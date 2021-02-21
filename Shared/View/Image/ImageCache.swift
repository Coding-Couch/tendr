//
//  ImageCache.swift
//
//
//  Created by Vince on 2020-10-31.
//  Copyright © 2020 EatSleepRIDE. All rights reserved.

import Combine
import Foundation
import SwiftUI
import MetricKit

class ImageCache {
	static let shared = ImageCache()
	private static let megabyteSize = 1024 * 1024 // 1MB
	
	#if os(iOS) || os(watchOS) || os(tvOS)
	private var cache: NSCache<NSString, UIImage> = {
		let cache = NSCache<NSString, UIImage>()
		cache.totalCostLimit = (megabyteSize * 100) // 100MB
		return cache
	}()
	#elseif os(macOS)
	private var cache: NSCache<NSString, NSImage> = {
		let cache = NSCache<NSString, NSImage>()
		cache.totalCostLimit = (megabyteSize * 100) // 100MB
		return cache
	}()
	#endif

	private var cancellable: AnyCancellable?

	private init() {
		#if os(iOS) || os(watchOS) || os(tvOS)
		cancellable = NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
			.sink { [weak self] _ in
				self?.clearCache()
			}
		#endif
	}

	deinit {
		cancellable?.cancel()
		clearCache()
	}
	
	#if os(iOS) || os(watchOS) || os(tvOS)
	func get(forKey: String) -> UIImage? {
		cache.object(forKey: NSString(string: forKey))
	}

	func set(forKey: String, image: UIImage) {
		cache.setObject(image, forKey: NSString(string: forKey))
	}
	#elseif os(macOS)
	func get(forKey: String) -> NSImage? {
		cache.object(forKey: NSString(string: forKey))
	}

	func set(forKey: String, image: NSImage) {
		cache.setObject(image, forKey: NSString(string: forKey))
	}
	#endif

	func remove(forKey: String) {
		cache.removeObject(forKey: NSString(string: forKey))
	}

	func clearCache() {
		cache.removeAllObjects()
	}
}
