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
    @StateObject var memeProvider = MemeProvider()

    // MARK: - Private Properties

    @State private var alertContent: AlertContent?

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
    }

    // MARK: - Subviews

    private var initialLoadIndicator: some View {
        HStack(spacing: .margin) {
            Text(L10n.History.State.initialLoad)
                .font(.caption)
                .fontWeight(.bold)

            ProgressView()
                .progressViewStyle(.circular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.horizontal)
    }

    private var pagingLoadIndicator: some View {
        HStack(spacing: .margin) {
            Text(L10n.History.State.paging)
                .font(.caption)
                .fontWeight(.bold)

            ProgressView()
                .progressViewStyle(.circular)
        }
        .listRowSeparator(.hidden)
        .frame(height: 44)
        .padding(.horizontal)
    }

    @ViewBuilder private var memeList: some View {
        List {
            if memeProvider.memes.isEmpty {
                initialLoadIndicator
                    .listRowSeparator(.hidden)
            }

            ForEach(memeProvider.memes, id: \.id) { meme in
                HistoryRowView(meme: meme)
                    .buttonStyle(.plain)
                    .onAppear {
                        let memes = memeProvider.memes

                        guard !memes.isEmpty else { return }

                        if let index = memes.firstIndex(of: meme),
                           index == memes.endIndex - 1 {
                            loadNextPage()
                        }
                    }
            }

            if memeProvider.isPaging {
                HStack(spacing: .margin) {
                    Text(L10n.History.State.paging)
                        .font(.caption)
                        .fontWeight(.bold)

                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .frame(height: 44)
                .padding(.horizontal)
            }
        }
        .onAppear {
            if memeProvider.initialLoad {
                loadNextPage()
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            memeProvider.clearMemes()
            loadNextPage()
        }
    }

    // MARK: - Helper Functions

    private func loadNextPage() {
        Task {
            do {
                try await memeProvider.loadMore()
            } catch let error as MemeProvider.MemeProviderError {
                alertContent = AlertContent(
                    title: L10n.History.Error.Tendr.title,
                    message: L10n.History.Error.Tendr.message(error.localizedDescription)
                )
            } catch {
                alertContent = AlertContent(
                    title: L10n.History.Error.Generic.title,
                    message: "\(String(describing: error))"
                )
            }
        }
    }
}

// MARK: - Previews

struct MemeHistoryList_Previews: PreviewProvider {
    static var previews: some View {
        MemeHistoryList(historyType: .like)
    }
}
