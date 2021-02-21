//
//  RoundButtonStyle.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import Foundation
import SwiftUI

struct RoundButtonStyle: ButtonStyle {
    
    var color: Color
    var diameter: CGFloat = 64
    
    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .frame(width: diameter, height: diameter)
            .foregroundColor(color)
            .overlay(
                configuration.label
                    .font(.title2)
                    .foregroundColor(.white)
            )
            .opacity(configuration.isPressed ? 0.6 : 1)
			.shadow(radius: .smallRadius)
    }
}

struct RoundButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            // action
        } label: {
			Image(systemName: "square.and.arrow.up")
        }
        .buttonStyle(RoundButtonStyle(color: .red))
    }
}
