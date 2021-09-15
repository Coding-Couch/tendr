//
//  HomeView.swift
//  Tendr
//
//  Designed in DetailsPro
//
//

import SwiftUI

struct HomeView: View {
    static private let offset: Int = 5

    @StateObject var memeProvider: SwipeMemeProvider = SwipeMemeProvider(offset: Self.offset)
    @State var swipingAction: MemeAction?
    @State var alertContent: AlertContent?

    var body: some View {
        NavigationView {
            homeView
                .task {
                    do {
                        let memesToLoad = Self.offset - memeProvider.memes.count

                        if memesToLoad > 0 {
                            try await memeProvider.loadMore(count: memesToLoad)
                        }
                    } catch {
                        print("Home View Error: \(error)")
                    }
                }
        }
        #if os(iOS)
        .navigationViewStyle(.stack)
        #endif
    }

    var homeView: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: .largeMargin) {
                Spacer()

                ZStack {
                    ForEach(memeProvider.memes.reversed()) { meme in
                        let index = memeProvider.memes.firstIndex(of: meme)!
                        let offset: CGFloat = CGFloat.smallMargin * CGFloat(index)

                        MemeCardView(
                            meme: meme,
                            swipe: handleSwipeAction(action:),
                            geometrySize: reader.size,
                            swipingAction: $swipingAction
                        )
                            .padding(.margin)
                            .shadow(radius: 5)
                            .opacity(memeProvider.memes.first != meme ? 0 : 1)
                            .offset(x: 0, y: -offset)
                    }

                    if memeProvider.memes.isEmpty {
                        MemeCardView.placeholder
                    }
                }

                if memeProvider.isLoading || memeProvider.isPaging {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.gray)
                        .scaleEffect(2.0)
                }

                Spacer()

                MemeButtonsView(actionPerformed: handleSwipeAction(action:))
                    .environmentObject(memeProvider)
            }
            .frame(maxWidth: reader.size.width, maxHeight: reader.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.systemBackground)
        .overlay(
            actionOverlay()
                .ignoresSafeArea()
        )
        .alert(item: $alertContent) { content in
            Alert(
                title: Text(content.title),
                message: content.standardMessage,
                dismissButton: .cancel()
            )
        }
        #if os(iOS)
        .ignoresSafeArea(edges: [.top, .horizontal])
        .navigationBarHidden(true)
        #elseif os(macOS)
        .frame(minWidth: 380, idealWidth: 800, maxWidth: .infinity)
        #endif
    }

    @ViewBuilder func actionOverlay() -> some View {
        switch swipingAction {
        case .like:
            HStack {
                Spacer()
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.clear, Color.green]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                    .frame(width: 100)
                    .overlay(swipingAction?.icon)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.opacity)
        case .dislike:
            HStack {
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.red, Color.clear]
                    ),
                    startPoint: .leading, endPoint: .trailing
                )
                    .frame(width: 100)
                    .overlay(swipingAction?.icon)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.opacity)
        case .skip:
            VStack(alignment: .center) {
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.grayLight, Color.clear]
                    ),
                    startPoint: .top, endPoint: .bottom
                )
                    .frame(height: 100)
                    .overlay(swipingAction?.icon)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.opacity)
        case .none:
            EmptyView()
        }
    }

    private func handleSwipeAction(action: MemeAction) {
        Task {
            do {
                try await memeProvider.action(action)
            } catch let error as MemeProvider.MemeProviderError {
                alertContent = AlertContent(
                    title: L10n.Home.Error.Tendr.title(action.name),
                    message: L10n.Home.Error.Tendr.message(error.localizedDescription)
                )
            } catch {
                alertContent = AlertContent(
                    title: L10n.Home.Error.Generic.title,
                    message: error.localizedDescription
                )
            }
        }
    }
}

struct MyDesign_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
