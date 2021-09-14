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
            memes.removeFirst()
            loadMore()
            return
        }

        /// Send API request for action
        if let endpoint = endpoint {
            let urlRequest = try? ApiRequest<Empty>(endpoint: endpoint).createURLRequest()
            if let urlRequest = urlRequest {
                cancellable?.cancel()
                cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
                    .receive(on: RunLoop.main)
                    .sink { (completion) in
                        switch completion {
                        case .failure:
                            break
                        case .finished:
                            break
                        }
                    } receiveValue: { [weak self] (_, urlResponse) in
                        guard let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.isSuccess else {
                            return
                        }

                        self?.memes.removeFirst()

                        self?.loadMore()
                    }
            }
        }
    }
}
