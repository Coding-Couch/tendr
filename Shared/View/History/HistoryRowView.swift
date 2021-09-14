//
//  HistoryRowView.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-21.
//

import SwiftUI

struct HistoryRowView: View {
    var meme: MemeDTO

    @State private var showShareSheet: Bool = false
    @State private var showMemeDetails: Bool = false

    var body: some View {
        NavigationLink(
            destination: MemeDetails(meme: meme),
            isActive: $showMemeDetails,
            label: { EmptyView() }
        )
        .frame(width: 0, height: 0)
        .hidden()

        #if os(iOS) || os(watchOS) || os(tvOS)
        memeRow
            .shareSheet(
                isPresented: $showShareSheet,
                sharedItems: [meme.url]
            )
        #elseif os(macOS)
        memeRow
        #endif
    }

    @ViewBuilder private var memeRow: some View {
        HStack {
            MemeImage(url: meme.url)
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 60, maxHeight: 60)
                .clipShape(RoundedRectangle(cornerRadius: .smallRadius))

            VStack(alignment: .leading, spacing: .margin) {

                Text("\(meme.url)")
                    .lineLimit(1)
                    .foregroundColor(.accentColor)

                HStack {
                    Label(
                        title: {
                            Text("\(meme.upvotes)")
                                .foregroundColor(.label)
                        },
                        icon: {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.orange)
                        }
                    )

                    Label(
                        title: {
                            Text("\(meme.downvotes)")
                                .foregroundColor(.label)
                        },
                        icon: {
                            Image(systemName: "arrow.down")
                                .foregroundColor(.blue)
                        }
                    )
                }
            }
            .padding(.vertical)
        }
        .padding(.smallMargin)
        .frame(minWidth: 250, maxWidth: .infinity, maxHeight: 80, alignment: .leading)
        .background(Color.systemBackground	)
        .clipShape(RoundedRectangle(cornerRadius: .smallRadius))
        .contentShape(RoundedRectangle(cornerRadius: .smallRadius))
        .contextMenu(
            menuItems: {
                #if os(iOS) || os(watchOS) || os(tvOS)
                Button {
                    shareMeme()
                } label: {
                    Label(L10n.ContextMenu.Action.share, systemImage: "square.and.arrow.up")
                }
                #elseif os(macOS)
                ShareMenu(sharedItems: [meme.url], showText: true)
                #endif

                Button {
                    openMemeInBrowser()
                } label: {
                    Label(L10n.ContextMenu.Action.browser, systemImage: "safari")

                }

                Button {
                    showMemeDetails = true
                } label: {
                    Label(L10n.ContextMenu.Action.open, systemImage: "arrow.up.right.square")
                }
            }
        )
        .contentShape(RoundedRectangle(cornerRadius: .smallRadius))
    }

    private func shareMeme() {
        showShareSheet = true
    }

    private func openMemeInBrowser() {
        #if os(iOS) || os(watchOS) || os(tvOS)
        if UIApplication.shared.canOpenURL(meme.url) {
            UIApplication.shared.open(meme.url, options: [:], completionHandler: nil)
        }
        #elseif os(macOS)
        _ = NSWorkspace.shared.open(meme.url)
        #endif
    }
}

struct HistoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryRowView(
                meme: MemeDTO(
                    id: "1234",
                    url: URL(string: "https://i.redd.it/00rr8gg4spi61.jpg")!,
                    upvotes: 1337,
                    downvotes: 337
                )
            )
        }
    }
}
