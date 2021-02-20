//
//  MemeProvider.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import Foundation

class MemeProvider: ObservableObject {
    @Published var memes: [MemeResponse]
    
    init() {
        memes = []
        loadMore(count: 5)
    }
    
    private func loadMore(count: Int = 1) {
        
    }
    
    func action(_ action: MemeAction) {
        guard let meme = memes.first else { return }
        
        /// Send API request to skip
        switch action {
        case .like:
            break
        case .skip:
            break
        case .dislike:
            break
        }
        
        /// removes the completed meme
        memes.remove(at: 0)
        
        /// adds a meme to the array
        loadMore()
        
    }
}
