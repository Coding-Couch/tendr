//
//  HistoryProvider.swift
//  Tendr
//
//  Created by Vince on 2021-02-20.
//

import SwiftUI

class HistoryProvider: ObservableObject {
    @Published var memes: [MemeResponse] = []

    /// Type of history - Likes or Dislikes
    var historyType: HistoryType? {
        didSet {
            memes = []
            nextPage()
        }
    }

    /// When an empty page is received, this is set to false so requests arent sent unnecessarily
    var canLoadNextPage = true

    /// offset to send to the API
    private var offset: Int {
        self.memes.count
    }

    private var networkClient = NetworkClient<Empty, [MemeResponse]>()

    init(historyType type: HistoryType) {
        defer {
            historyType = type
        }
    }

    func nextPage(count: Int = 10) {
        guard canLoadNextPage else { return }

        let request = ApiRequest<Empty>(endpoint: .history(type: historyType, limit: count, offset: offset))

        networkClient.request = request
        networkClient.load()
    }
}
