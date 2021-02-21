//
//  MemeSwipeView.swift
//  Tendr
//
//  Designed in DetailsPro
//
//

import SwiftUI

struct MemeSwipeView: View {
    @ObservedObject var memeProvider: MemeProvider = MemeProvider()
    @State var swipingAction: MemeAction?
    
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
        case .none:
            EmptyView()
        }
    }
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: .largeMargin) {
                Spacer()
                
                ZStack(alignment: .top) {
                    ForEach(memeProvider.memes.reversed(), id: \.id) { meme in
                        MemeCardView(
                            url: meme.url,
                            swipe: { memeProvider.action($0)
                            },
                            geometrySize: reader.size,
                            swipingAction: $swipingAction
                        )
                        .padding(.margin)
                        .shadow(radius: 5)
                        .opacity(memeProvider.memes.first != meme ? 0 : 1)
                    }
                }
                Spacer()
                MemeButtonsView()
                    .environmentObject(memeProvider)
                    .padding(.top, .largeMargin)
                Spacer()
            }
            .frame(maxWidth: reader.size.width, maxHeight: reader.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding()
        .background(Color.secondarySystemBackground)
        .overlay(actionOverlay())
        .ignoresSafeArea()
    }
}

struct MyDesign_Previews: PreviewProvider {
    static var previews: some View {
        MemeSwipeView()
    }
}
