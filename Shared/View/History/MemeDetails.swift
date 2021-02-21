//
//  MemeDetails.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-21.
//

import SwiftUI

struct MemeDetails: View {
	var meme: MemeResponse
	
	@State private var showShareSheet: Bool = false
	
	var body: some View {
		#if os(iOS) || os(watchOS) || os(tvOS)
		mainView
			.navigationBarTitle(Text("Meme Details"), displayMode: .inline)
			.navigationBarItems(
				trailing: Button {
					showShareSheet = true
				} label: {
					Image(systemName: "square.and.arrow.up")
				}
			)
		#elseif os(macOS)
		mainView
			.navigationTitle(Text("Meme Details"))
		#endif
	}
	
	@ViewBuilder private var mainView: some View {
		ZStack(alignment: .top) {
			Color.secondarySystemBackground
				.edgesIgnoringSafeArea(.all)
			
			VStack(spacing: .margin) {
				AsyncImage(url: meme.url) {
					Image("meme-not-found")
						.resizable()
						.aspectRatio(contentMode: .fit)
				}
				.aspectRatio(contentMode: .fit)
				.cornerRadius(.cornerRadius)
				.shadow(radius: .smallRadius)
				.contextMenu(
					menuItems: {
						#if os(iOS) || os(watchOS) || os(tvOS)
						Button {
							shareMeme()
						} label: {
							Label("Share", systemImage: "square.and.arrow.up")
						}
						#endif


						Button {
							openMemeInBrowser()
						} label: {
							Label("Open in Browser", systemImage: "safari")

						}
					}
				)
				.contentShape(RoundedRectangle(cornerRadius: .smallRadius))
				
				RoundedRectangle(cornerRadius: .cornerRadius)
					.fill(Color.systemBackground)
					.shadow(radius: .smallRadius)
					.overlay(
						detailsView,
						alignment: .top
					)
			}
			.padding()
		}
	}
	
	@ViewBuilder private var detailsView: some View {
		VStack(alignment: .leading, spacing: .smallMargin) {
			Text("Meme Details")
				.font(.title)
			
			HStack{
				Label("Source: ", systemImage: "network")
				Text("Reddit")
			}
			
			HStack {
				Label("Image Url: ", systemImage: "chevron.left.slash.chevron.right")
				Text("\(meme.url.absoluteString)")
					.lineLimit(1)
					.foregroundColor(.accentColor)
					.onTapGesture {
						openMemeInBrowser()
					}
			}
			
			HStack {
				Label(
					title: { Text("Reddit Upvote Count: ") },
					icon: {
						Image(systemName: "arrow.up")
							.foregroundColor(.orange)
						
					}
				)
				
				Text("\(meme.upvotes)")
			}
			
			HStack{
				Label(
					title: { Text("Reddit Downvote Count: ") },
					icon: {
						Image(systemName: "arrow.down")
							.foregroundColor(.accentColor)
						
					}
				)
				
				Text("\(meme.downvotes)")
			}
		}
		.padding()
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	private func shareMeme() {
		showShareSheet = true
	}
	
	private func openMemeInBrowser() {
		#if os(iOS) || os(watchOS) || os(tvOS)
		if UIApplication.shared.canOpenURL(meme.url) {
			UIApplication.shared.open(meme.url, options: [:], completionHandler: nil)
		}
		#elseif os(macOS)
		let _ = NSWorkspace.shared.open(meme.url)
		#endif
	}
}

struct MemeDetails_Previews: PreviewProvider {
	static var previews: some View {
		MemeDetails(
			meme: MemeResponse(
				id: "1234",
				url: URL(string: "https://i.redd.it/00rr8gg4spi61.jpg")!,
				upvotes: 1337,
				downvotes: 337
			)
		)
	}
}
