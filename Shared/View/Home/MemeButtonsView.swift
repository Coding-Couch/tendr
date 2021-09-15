//
//  MemeButtonsView.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct MemeButtonsView: View {
    var actionPerformed: (MemeAction) -> Void

    var body: some View {
        HStack(spacing: .largeMargin) {
            ForEach(MemeAction.allCases, id: \.self) { memeAction in
                Button {
                    actionPerformed(memeAction)
                } label: {
                    memeAction.icon
                }
                .buttonStyle(RoundButtonStyle(color: memeAction.color))
            }
        }
    }
}

struct MemeButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        MemeButtonsView { action in
            print(action.name)
        }
    }
}
