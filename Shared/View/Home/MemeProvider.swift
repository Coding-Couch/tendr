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
        
        let urlRequest = try? ApiRequest<EmptyRequest>(endpoint: Endpoint.memes(sorted: nil), requestBody: nil).createURLRequest()
        
        guard let request = urlRequest else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .decode(type: [MemeResponse].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .sink(receiveCompletion: {  [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }, receiveValue: { [weak self] payload in
                guard let self = self else { return }
                
                self.memes.append(contentsOf: payload.filter { !$0.url.absoluteString.contains(".gif") })
            })
    }
    func action(_ action: MemeAction) {
        guard let meme = memes.first else { return }
        
        /// Send API request to skip
        print("ACTION - \(action)")
        
        /// removes the completed meme
        memes.removeFirst()
        
        /// adds a meme to the array
        loadMore()
        
    }
}
