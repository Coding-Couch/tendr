//
//  MemeProvider.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI
import OSLog

@MainActor class MemeProvider: ObservableObject {
    // MARK: - Structures

    enum MemeProviderError: Error, LocalizedError {
        case httpStatus(code: Int)
        case unknown(description: String)

        var errorDescription: String? {
            switch self {
            case let .httpStatus(code):
                return "Tendr Api returned a bad status code: \(code)"
            case let .unknown(description):
                return description
            }
        }
    }

    // MARK: - Public Properties

    @Published var memes: [MemeDTO] = []
    @Published var isLoading: Bool = false

    var initialLoad: Bool = true

    var isPaging: Bool {
        isLoading && !memes.isEmpty
    }

    // MARK: - Private Properties

    fileprivate lazy var session = URLSession.shared
    fileprivate lazy var decoder = JSONDecoder()
    fileprivate lazy var logger = Logger(subsystem: bundleId, category: "Meme Provider")
    fileprivate let offset: Int
    private var currentOffset: Int = 0
    private var totalCount: Int = 0

    // MARK: - Lifecycle

    init(offset: Int = 20) {
        self.offset = offset
    }

    // MARK: - Functions

    func loadMore(count: Int? = nil) async throws {
        try await loadMore(count: count != nil ? count! : offset)
    }

    private func loadMore(count: Int = 20) async throws {
        withAnimation {
            isLoading = true
        }

        defer {
            withAnimation {
                isLoading = false
            }
            initialLoad = false
        }

        let urlRequest = try ApiRequest<Empty>(endpoint: .memes(limit: currentOffset, offset: offset))
            .createURLRequest()

        let (data, urlResponse) = try await session.data(for: urlRequest)

        try handleUrlResponse(urlResponse: urlResponse)

        let response = try decoder.decode(MemeResponse.self, from: data)

        currentOffset = response.currentOffset
        totalCount = response.totalCount
        memes.append(contentsOf: response.memes)
    }

    func clearMemes() {
        totalCount = 0
        currentOffset = 0
        initialLoad = true

        withAnimation {
            memes = []
        }
    }

    fileprivate func handleUrlResponse(urlResponse: URLResponse) throws {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            logger.critical("URLResponse could not be cast to HTTPURLResponse.\nDetails:\n\(urlResponse)")
            throw MemeProviderError.unknown(description: "URLResponse could not be cast to HTTPURLResponse")
        }

        guard httpResponse.isSuccess else {
            logger.error("Bad HTTP Response: \(httpResponse)")
            throw MemeProviderError.httpStatus(code: httpResponse.statusCode)
        }
    }
}

@MainActor class SwipeMemeProvider: MemeProvider {
    func action(_ action: MemeAction) async throws {
        guard let meme = memes.first else { return }

        switch action {
        case .like:
            try await voteForMeme(endpoint: .like(id: meme.id))
        case .dislike:
            try await voteForMeme(endpoint: .dislike(id: meme.id))
        case .skip:
            memes.removeFirst()
        }

        if memes.count < offset {
            try await loadMore()
        }
    }

    private func voteForMeme(endpoint: Endpoint) async throws {
        let urlRequest = try ApiRequest<Empty>(endpoint: endpoint).createURLRequest()

        withAnimation {
            isLoading = true
        }

        defer {
            withAnimation {
                isLoading = false
            }
        }

        print(urlRequest)

        let (data, urlResponse) = try await session.data(for: urlRequest)
        try handleUrlResponse(urlResponse: urlResponse)
        memes.removeFirst()
    }
}
