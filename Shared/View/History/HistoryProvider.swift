//
//  HistoryProvider.swift
//  Tendr
//
//  Created by Vince on 2021-02-20.
//

import SwiftUI

class HistoryProvider: ObservableObject {
    @Published var memes: [MemeResponse] = []
    var historyType: HistoryType? {
        didSet {
            memes = []
            nextPage()
        }
    }
    
    private var offset: Int = 0
    
    init(historyType type: HistoryType) {
        defer {
            historyType = type
        }
    }
    
    func nextPage() {
        for index in 1...100 {
            memes.append(MemeResponse(id: "Go To Number: \(index)", url: URL(string: "https://www.google.ca")!, upvotes: index, downvotes: index))
        }
    }
}
