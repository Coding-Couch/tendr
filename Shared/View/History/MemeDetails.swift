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
		#if os(iOS)
		mainView
			.shareSheet(isPresented: $showShareSheet, sharedItems: [meme.url])
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
			.frame(minWidth: 360, idealWidth: 560, maxWidth: .infinity)
			.navigationTitle(Text("Meme Details"))
			.toolbar {
				ToolbarItem {
					ShareMenu(sharedItems: [meme.url.absoluteString])
				}
			}
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
							showShareSheet = true
						} label: {
							Label("Share", systemImage: "square.and.arrow.up")
						}
						
						Button {
							let pasteboard = UIPasteboard.general
							pasteboard.string = meme.url.absoluteString
						} label: {
							Image(systemName: "doc.on.doc")
							Text("Copy")
						}
						#elseif os(macOS)
						ShareMenu(sharedItems: [meme.url.absoluteString], showText: true)
						#endif

						Button {
							openMemeInBrowser()
						} label: {
							Image(systemName: "safari")
							Text("Open in Browser")
						}
					}
				)
				.contentShape(RoundedRectangle(cornerRadius: .smallRadius))
				
				detailsView
					.background(Color.systemBackground)
					.clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
					.shadow(radius: .smallRadius)
				
				Spacer()
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
		NavigationView {
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
}
