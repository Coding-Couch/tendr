//
//  MemeCardView.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct MemeCardView: View {
    var url: URL
    
    var body: some View {
        AsyncImage(url: url)
            .aspectRatio(contentMode: .fit)
            .cornerRadius(.cornerRadius)
            .padding(.margin)
            .frame(maxWidth: 600)
            .foregroundColor(.secondarySystemBackground)
            .background(
                RoundedRectangle(
                    cornerRadius: .cornerRadius)
                    .foregroundColor(.secondarySystemBackground)
                    .shadow(color: .secondary, radius: 8, x: 0, y: 14)
            )
            
            .onTapGesture {
                #warning("Add full screen?")
            }
    }
}

struct MemeCardView_Previews: PreviewProvider {
    static var previews: some View {
        MemeCardView(url: URL(string: "https://cdn.vox-cdn.com/thumbor/cV8X8BZ-aGs8pv3D-sCMr5fQZyI=/1400x1400/filters:format(png)/cdn.vox-cdn.com/uploads/chorus_asset/file/19933026/image.png")!)
        
        MemeCardView(url: URL(string: "https://cdn.vox-cdn.com/thumbor/cV8X8BZ-aGs8pv3D-sCMr5fQZyI=/1400x1400/filters:format(png)/cdn.vox-cdn.com/uploads/chorus_asset/file/19933026/image.png")!).colorScheme(.dark)
    }
}
