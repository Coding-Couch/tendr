//
//  AsyncImage.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader
    private var onError: (() -> Void)? = nil
    
    init(
        url: URL,
        onError: (() -> Void)? = nil
    ) {
        self.onError = onError
        _loader = StateObject(
            wrappedValue: ImageLoader(url: url)
        )
    }
    
    var body: some View {
        VStack {
            switch loader.status {
            case .initial, .loading:
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle()
                    )
            case .loaded:
                if let image = loader.image {
                    image.resizable()
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
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(
            url: URL(
                string:
                    "https://i1.sndcdn.com/artworks-000248046424-aokz4t-t500x500.jpg")!)
    }
}
