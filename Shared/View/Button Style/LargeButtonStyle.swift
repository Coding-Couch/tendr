//
//  LargeButtonStyle.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation
import SwiftUI

struct LargeButtonStyle: ButtonStyle {

    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: .smallerRadius)
            .fill(color)
            .overlay(
                configuration.label
                    .font(Font.body.weight(.bold))
                    .foregroundColor(.white)
            )
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

struct LargeButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            // action
        } label: {
            Text("Hello World!")
        }
        .buttonStyle(LargeButtonStyle(color: .blue))
        .frame(height: 48)
    }
}
