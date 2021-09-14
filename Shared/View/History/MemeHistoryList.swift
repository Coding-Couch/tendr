//
//  MemeHistoryList.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-03-01.
//

import SwiftUI

struct MemeHistoryList: View {
    // MARK: - Public Properties

    var historyType: HistoryType
    @StateObject var memeProvider = NetworkClient<Empty, [MemeResponse]>()

    // MARK: - Private Properties

    @State private var memes: [MemeResponse] = []
    @State private var currentOffset: Int = 0
    @State private var alertContent: AlertContent?
    @State private var endOfList: Bool = false
    private let limit: Int = 20

    var body: some View {
        memeList
            .alert(item: $alertContent) { alertContent in
                Alert(
                    title: Text(alertContent.title),
                    message: alertContent.standardMessage,
                    dismissButton: .cancel()
                )
            }
            .onAppear {
                guard memeProvider.request == nil else { return }
                memeProvider.request = ApiRequest(
                    endpoint: .history(type: historyType, limit: limit, offset: currentOffset)
                )
                memeProvider.load()
            }
            .onReceive(memeProvider.$response) { memes in
                guard let memes = memes else { return }
                guard !memes.isEmpty else {
                    endOfList = true
                    return
                }

                if memes.count < limit {
                    endOfList = true
                }

                withAnimation {
                    self.memes.append(contentsOf: memes)
                }

                self.currentOffset = memes.count
            }
            .onReceive(memeProvider.$urlResponse) { urlResponse in
                guard let urlResponse = urlResponse,
                      !urlResponse.isSuccess else {
                    return
                }

                alertContent = AlertContent(
                    title: L10n.History.Error.Tendr.title,
                    message: L10n.History.Error.Tendr.message(urlResponse.statusCode)
                )
            }
            .onReceive(memeProvider.$error) { error in
                guard let error = error else { return }

                alertContent = AlertContent(
                    title: L10n.History.Error.Generic.title,
                    message: "\(String(describing: error))"
                )
            }
    }

    // MARK: - Subviews

    @ViewBuilder private var memeList: some View {
        if currentOffset == 0 {
            HStack(spacing: .margin) {
                Text(L10n.History.State.initialLoad)
                    .font(.caption)
                    .fontWeight(.bold)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            .frame(height: 44)
            .padding(.horizontal)
        } else if !memes.isEmpty {
            List {
                ForEach(memes, id: \.id) { meme in
                    NavigationLink(destination: MemeDetails(meme: meme)) {
                        HistoryRowView(meme: meme)
                            .buttonStyle(PlainButtonStyle())
                            .onAppear {
                                guard !memes.isEmpty else { return }

                                if let index = memes.firstIndex(of: meme),
                                   index == memes.endIndex - 1 {
                                    loadNextPage()
                                }
                            }
                    }
                }

                if memeProvider.isLoading {
                    HStack(spacing: .margin) {
                        Text(L10n.History.State.paging)
                            .font(.caption)
                            .fontWeight(.bold)

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(height: 44)
                    .padding(.horizontal)
                }
            }
        }
    }

    // MARK: - Helper Functions

    private func loadNextPage() {
        guard !memes.isEmpty else { return }
        guard !endOfList else { return }
        memeProvider.request = ApiRequest(endpoint: .history(type: historyType, limit: limit, offset: currentOffset))
        memeProvider.load()
    }
}

// MARK: - Previews
#if DEBUG
struct MemeHistoryList_Previews: PreviewProvider {
    static var previews: some View {
        MemeHistoryList(historyType: .like)
    }
}
#endif
