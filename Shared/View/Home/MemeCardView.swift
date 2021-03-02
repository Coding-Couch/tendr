//
//  MemeCardView.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct MemeCardView: View {
	var meme: MemeResponse
	var swipe: (MemeAction) -> Void
	var geometrySize: CGSize
	@Binding var swipingAction: MemeAction?
	@State private var translation: CGSize = .zero
	@State private var showMeme: Bool = false
	
	private static var thresholdPercentage: CGFloat = 0.25
	
	var body: some View {
		NavigationLink(
			destination: MemeDetails(meme: meme),
			isActive: $showMeme,
			label: {
				EmptyView()
			}
		)
		.frame(width: 0, height: 0)
		.hidden()
		
		AsyncImage(url: meme.url) {
			Image("meme-not-found")
		}
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
			showMeme = true
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
				meme: MemeResponse(
					id: "1234",
					url: URL(string: "https://i.redd.it/00rr8gg4spi61.jpg")!,
					upvotes: 1337,
					downvotes: 337
				),
				swipe: {_ in }, geometrySize: reader.size,
				swipingAction: .constant(nil)
			)
		}
		
		GeometryReader{ reader in
			MemeCardView(
				meme: MemeResponse(
					id: "1234",
					url: URL(string: "https://i.redd.it/00rr8gg4spi61.jpg")!,
					upvotes: 1337,
					downvotes: 337
				),
				swipe: {_ in }, geometrySize: reader.size,
				swipingAction: .constant(nil)
			)
		}
		.colorScheme(.dark)
	}
}
