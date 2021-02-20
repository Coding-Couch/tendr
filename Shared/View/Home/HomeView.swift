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
    
    var body: some View {
        VStack(alignment: .center, spacing: .largeMargin) {
            ZStack {
                ForEach(memeProvider.memes.reversed(), id: \.id) { meme in
                    MemeCardView(url: meme.url)
                        .padding(.margin)
                }
            }
            MemeButtonsView()
                .environmentObject(memeProvider)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondarySystemBackground)
        .ignoresSafeArea()
    }
}

struct MyDesign_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
