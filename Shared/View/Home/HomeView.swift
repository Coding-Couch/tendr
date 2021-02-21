//
//  HomeView.swift
//  Tendr
//
//  Designed in DetailsPro
//
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var memeProvider: MemeProvider = MemeProvider()
    @State var swipingAction: MemeAction?
    
    @ViewBuilder func actionOverlay() -> some View {
        let overlayThickness: CGFloat = 50
        switch swipingAction {
        case .like:
            HStack {
                Spacer()
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.green.opacity(0), Color.green]
                    ),
                    startPoint: .leading, endPoint: .trailing
                )
                .frame(width: overlayThickness)
                .overlay(
                    swipingAction?.icon
                        .foregroundColor(.white)
                        .font(.title)
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .dislike:
            HStack {
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.red, Color.red.opacity(0)]
                    ),
                    startPoint: .leading, endPoint: .trailing
                )
                .frame(width: overlayThickness)
                .overlay(
                    swipingAction?.icon
                        .foregroundColor(.white)
                        .font(.title)
                )
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .skip:
            VStack(alignment: .center) {
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.gray, Color.gray.opacity(0)]
                    ),
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: overlayThickness * 2 )
                .overlay(
                    swipingAction?.icon
                        .foregroundColor(.white)
                        .font(.title)
                )
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
                        if memeProvider.memes.first == meme {
                            MemeCardView(
                                url: meme.url,
                                swipe: { memeProvider.action($0)
                                },
                                geometrySize: reader.size,
                                swipingAction: $swipingAction
                            )
                            .padding(.margin)
                            .shadow(radius: 5)
                        } else {
                            MemeCardView(
                                url: meme.url,
                                swipe: { memeProvider.action($0)
                                },
                                geometrySize: reader.size,
                                swipingAction: $swipingAction
                            )
                            .padding(.margin)
                            .opacity(0)
                        }
                    }
                }
                .frame(height: reader.size.height/1.5)
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
        .overlay(actionOverlay().animation(.easeIn))
        .ignoresSafeArea()
    }
}

struct MyDesign_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
