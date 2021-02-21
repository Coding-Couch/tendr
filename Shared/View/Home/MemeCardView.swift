//
//  MemeCardView.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct MemeCardView: View {
    var url: URL
    var swipe: (MemeAction) -> Void
    var geometrySize: CGSize
    @Binding var swipingAction: MemeAction?
    @State private var translation: CGSize = .zero
    
    private static var thresholdPercentage: CGFloat = 0.25
    
    var body: some View {
		AsyncImage(url: url) { EmptyView() }
            .aspectRatio(contentMode: .fit)
            .cornerRadius(.cornerRadius)
            .padding(.margin)
            .frame(
                maxWidth: geometrySize.width,
                maxHeight: geometrySize.height/2
            )
            .foregroundColor(.secondarySystemBackground)
            //                .background(
            //                    RoundedRectangle(
            //                        cornerRadius: .cornerRadius)
            //                        .foregroundColor(.secondarySystemBackground)
            //                        .shadow(color: .secondary, radius: 8, x: 0, y: 14)
            //                )
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: self.translation.height)
            .rotationEffect(
                .degrees(Double(self.translation.width / geometrySize.width) * 25),
                anchor: .bottom
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                        self.swipingAction = value.translation.swipeDirection.asMemeAction
                    }
                    .onEnded { value in
                        /// remove overlay
                        self.swipingAction = nil
                        
                        /// complete swipe
                        switch value.translation.swipeDirection {
                        case .up:
                            self.swipe(.skip)
                        case .down:
                            self.translation = .zero
                        case .left:
                            self.swipe(.dislike)
                        case .right:
                            self.swipe(.like)
                        }
                    }
            )
            .onTapGesture {
                #warning("Add full screen?")
            }
    }
}

fileprivate extension CGSize {
    var isUpSwipe: Bool { self.height < 0 }
    var isDownSwipe: Bool { self.height < 0 }
    var isRightSwipe: Bool { self.width > 0 }
    var isLeftSwipe: Bool { self.width < 0 }
    
    enum Direction {
        case up
        case down
        case left
        case right
        
        var asMemeAction: MemeAction? {
            switch self {
            case .up:
                return .skip
            case .down:
                return nil
            case .left:
                return .dislike
            case .right:
                return .like
            }
        }
    }
    
    var swipeDirection: Direction {
        /// Determine the drag distance of each axis
        let verticalDirection = abs(self.height)
        let horizontalDirection = abs(self.width)
        
        /// If its more of a vertical drag than horizonal
        if verticalDirection > horizontalDirection {
            return self.isUpSwipe ? .up : .down
        } else {
            return self.isLeftSwipe ? .left : .right
        }
    }
}

struct MemeCardView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ reader in
            MemeCardView(
                url: URL(string: "https://cdn.vox-cdn.com/thumbor/cV8X8BZ-aGs8pv3D-sCMr5fQZyI=/1400x1400/filters:format(png)/cdn.vox-cdn.com/uploads/chorus_asset/file/19933026/image.png")!,
                swipe: {_ in }, geometrySize: reader.size,
                swipingAction: .constant(nil)
            )
        }
        
        GeometryReader{ reader in
            MemeCardView(
                url: URL(string: "https://cdn.vox-cdn.com/thumbor/cV8X8BZ-aGs8pv3D-sCMr5fQZyI=/1400x1400/filters:format(png)/cdn.vox-cdn.com/uploads/chorus_asset/file/19933026/image.png")!,
                swipe: {_ in }, geometrySize: reader.size,
            swipingAction: .constant(nil)
            )
        }
        .colorScheme(.dark)
    }
}
