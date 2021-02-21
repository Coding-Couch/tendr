//
//  MemeProvider.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI
import Combine

class MemeProvider: ObservableObject {
    @Published var memes: [MemeResponse]
    private var offset: Int = 0
    private var cancellable: AnyCancellable?
    
    init() {
        memes = []
        loadMore(count: 5)
    }
    
    private func loadMore(count: Int = 1) {
        cancellable?.cancel()
        
		let urlRequest = try? ApiRequest<Empty>(endpoint: Endpoint.memes(limit: count, offset: offset), requestBody: nil).createURLRequest()
        
        guard let request = urlRequest else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .receive(on: RunLoop.main)
            .decode(type: [MemeResponse].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }, receiveValue: { [weak self] payload in
                guard let self = self else { return }
                
                self.offset += payload.count
                self.memes.append(contentsOf: payload)
            })
    }
    
    func action(_ action: MemeAction) {
        guard let meme = memes.first else { return }
        
        var endpoint: Endpoint?
        
        switch action {
        case .like:
            endpoint = .like(id: meme.id)
        case .dislike:
            endpoint = .dislike(id: meme.id)
        case .skip:
            break
        }
        
        /// Send API request for action
        if let endpoint = endpoint {
            let urlRequest = try? ApiRequest<Empty>(endpoint: endpoint).createURLRequest()
            
            if let urlRequest = urlRequest {
            
                URLSession.shared.dataTaskPublisher(for: urlRequest)
                    .map(\.data)
                    .decode(type: MemeResponse.self, decoder: JSONDecoder())
                            .receive(on: RunLoop.main)
                            .sink(receiveCompletion: { [weak self] completion in
                                guard let self = self else { return }
                                
                                switch completion {
                                case .finished:
                                    /// Remove the top meme
                                    self.memes.removeFirst()
                                    
                                    /// adds a meme to the array
                                    self.loadMore()
                                case .failure(let error):
                                    #warning("Handle error")
                                }
                            }, receiveValue: { _ in })
            }
        }
    }
}
