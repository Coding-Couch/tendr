//
//  AsyncImageLoader.swift
//  Tendr (iOS)
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var status: Status
    private let url: URL
    private var cancellable: AnyCancellable?
    
    public enum Status {
        case initial
        case loading
        case loaded
        case error(error: String)
    }

    init(url: URL) {
        self.url = url
        self.status = .initial
        self.load()
    }

    deinit {
        cancel()
    }
    
    func load() {
        cancellable?.cancel()
        cancellable = nil
        
        self.status = .loading
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .handleEvents(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.status = .loaded
                    case .failure(let error):
                        self?.status = .error(error: error.localizedDescription)
                    }
                    
                },
                receiveCancel: { [weak self] in
                    self?.status = .error(error: "Cancelled")
                }
            )
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}
