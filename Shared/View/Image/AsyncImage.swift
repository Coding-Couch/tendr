//
//  AsyncImage.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import Combine
import SwiftUI

/// Display's the specified image from a url.
/// If the image fails to load, the specified placeholder view is displayed instead
///	 - Note:
///		- images are cached on load to save data
///		- cache holds up to 100mb of images before images start being cleared
///		- cache is wiped on system memory warning
public struct AsyncImage<Placeholder: View>: View {
	@StateObject private var imageloader: ImageLoader
	private let placeholder: Placeholder?

	/// Return an `AsyncImage`.
	/// - Parameters:
	///   - url: url in which the image will be loaded from.
	///   - placeholder: placeholder view that will display on failure to load image.
	public init(url: URL, @ViewBuilder placeholder: () -> Placeholder? = {nil}) {
		_imageloader = StateObject(wrappedValue: ImageLoader(url: url))
		self.placeholder = placeholder()
	}

	public var body: some View {
		ZStack {
			if let image = imageloader.image {
				#if os(iOS) || os(watchOS) || os(tvOS)
				Image(uiImage: image)
					.resizable()
				#elseif os(macOS)
				Image(nsImage: image)
					.resizable()
				#endif
			} else {
				placeholder
			}
			
			if imageloader.loading {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
			}
		}
		.onReceive(imageloader.$url) { _ in
			imageloader.load()
		}
		.onDisappear {
			imageloader.cancel()
		}
	}
}

struct AsyncImage_Previews: PreviewProvider {
	private static var placeholder: some View {
		Image(systemName: "photo")
			.resizable()
			.aspectRatio(contentMode: .fit)
			.foregroundColor(.gray)
			.padding()
	}

	static var previews: some View {
		Group {
			AsyncImage(url: URL(string: "https://i.ytimg.com/vi/j2X8tqgsHCU/maxresdefault.jpg")!) {
				placeholder
			}
			.previewDisplayName("Shows Downloaded Image")
			.previewLayout(.sizeThatFits)

			AsyncImage(
				url: URL(string: "esr://brokenphoto")!) {
				placeholder
			}
			.previewDisplayName("Shows Placeholder")
			.previewLayout(.sizeThatFits)
		}
	}
}
