//
//  AsyncImage.swift
//  Tendr (iOS)
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    private var onError: (() -> Void)? = nil
    
    init(
        url: URL,
        onError: (() -> Void)? = nil,
        @ViewBuilder placeholder: () -> Placeholder? = {nil}
    ) {
        self.placeholder = placeholder()
        self.onError = onError
        _loader = StateObject(
            wrappedValue: ImageLoader(url: url)
        )
    }
    
    var body: some View {
        VStack {
            switch loader.status {
            case .initial:
                placeholder
            case .loading:
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle()
                    )
            case .loaded:
                if let uiImage = loader.image {
                    Image(uiImage: uiImage)
                }
            case .error:
                Text("erroe")
            }
        }
        .onDisappear {
            loader.cancel()
        }
        .onReceive(loader.$status, perform: { status in
            switch status {
            case .error(_):
                if let onError = self.onError {
                    onError()
                }
            default: break
            }
        }
        )
    }
    
    private var content: some View {
        placeholder
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(
            url: URL(
                string:
                    "https://i1.sndcdn.com/artworks-000248046424-aokz4t-t500x500.jpg")!,
            placeholder: { Image(systemName: "photo") })
    }
}
