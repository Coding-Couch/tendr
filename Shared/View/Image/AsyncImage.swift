//
//  AsyncImage.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import Combine
import SwiftUI
import Kingfisher

public struct AsyncImage<Placeholder: View>: View {
    private let placeholder: Placeholder?
    private let url: URL?
    @State private var progress: Float = 0
    @State private var totalProgress: Float = 100
    @State private var isLoaded: Bool = false

    /// Return an `AsyncImage`.
    /// - Parameters:
    ///   - url: url in which the image will be loaded from.
    ///   - placeholder: placeholder view that will display on failure to load image.
    public init(url: URL?, @ViewBuilder placeholder: () -> Placeholder? = {nil}) {
        self.url = url
        self.placeholder = placeholder()
    }

    public var body: some View {
        KFImage(url, isLoaded: $isLoaded)
            .placeholder {placeholder}
            .resizable()
            .onProgress { (recievedSize, totalSize) in
                withAnimation {
                    progress = Float(recievedSize)
                    totalProgress = Float(totalSize)
                }
            }
            .onFailure { _ in
                withAnimation {
                    isLoaded = true
                }
            }
            .overlay(
                progressView,
                alignment: .bottom
            )
    }

    @ViewBuilder private var progressView: some View {
        if !isLoaded {
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .blur(radius: 1.5)

                ProgressView(value: progress, total: totalProgress)
            }
            .transition(.opacity)
        }
    }
}

#if DEBUG
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
            // Test a very large image.
            AsyncImage(url: URL(string: "https://eoimages.gsfc.nasa.gov/images/imagerecords/73000/73580/world.topo.bathy.200401.3x21600x21600.A2.jpg")!) {
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
#endif
