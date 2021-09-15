//
//  MemeDetails.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-21.
//

import SwiftUI

struct MemeDetails: View {
    var meme: MemeDTO

    @State private var showShareSheet: Bool = false

    var body: some View {
        #if os(iOS)
        mainView
            .shareSheet(isPresented: $showShareSheet, sharedItems: [meme.url])
            .navigationBarTitle(Text("Meme Details"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            )
        #elseif os(macOS)
        mainView
            .frame(minWidth: 360, idealWidth: 425, maxWidth: 500)
            .navigationTitle(Text("Meme Details"))
            .toolbar {
                ToolbarItem {
                    ShareMenu(sharedItems: [meme.url])
                }
            }
        #endif
    }

    @ViewBuilder private var mainView: some View {
        ZStack(alignment: .top) {
            Color.secondarySystemBackground
                .ignoresSafeArea()

            VStack(spacing: .margin) {
                MemeImage(url: meme.url)
                    .scaledToFit()
                    .cornerRadius(.cornerRadius)
                    .shadow(radius: .smallRadius)
                    .contextMenu(
                        menuItems: {
                            #if os(iOS) || os(watchOS) || os(tvOS)
                            Button {
                                showShareSheet = true
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }

                            Button {
                                let pasteboard = UIPasteboard.general
                                pasteboard.url = meme.url
                            } label: {
                                Image(systemName: "doc.on.doc")
                                Text("Copy")
                            }
                            #elseif os(macOS)
                            ShareMenu(sharedItems: [meme.url], showText: true)
                            #endif

                            Button {
                                openMemeInBrowser()
                            } label: {
                                Image(systemName: "safari")
                                Text("Open in Browser")
                            }
                        }
                    )
                    .contentShape(RoundedRectangle(cornerRadius: .smallRadius))

                detailsView
                    .background(Color.systemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
                    .shadow(radius: .smallRadius)

                Spacer()
            }
            .padding()
        }
    }

    @ViewBuilder private var detailsView: some View {
        VStack(alignment: .leading, spacing: .smallMargin) {
            Text(L10n.Meme.Text.title)
                .font(.title)

            HStack {
                Label(L10n.Meme.Text.source, systemImage: "network")
                Text("Reddit")
            }

            HStack {
                Label(L10n.Meme.Text.url, systemImage: "chevron.left.slash.chevron.right")
                Text("\(meme.url.absoluteString)")
                    .lineLimit(1)
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        openMemeInBrowser()
                    }
            }

            HStack {
                Label(
                    title: { Text(L10n.Meme.Text.upvotes) },
                    icon: {
                        Image(systemName: "arrow.up")
                            .foregroundColor(.orange)
                    }
                )

                Text("\(meme.upvotes)")
            }

            HStack {
                Label(
                    title: { Text(L10n.Meme.Text.downvotes) },
                    icon: {
                        Image(systemName: "arrow.down")
                            .foregroundColor(.accentColor)
                    }
                )

                Text("\(meme.downvotes)")
            }
        }
        .padding()
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

struct MemeDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MemeDetails(
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
