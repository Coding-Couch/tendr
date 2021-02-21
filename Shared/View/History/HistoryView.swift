//
//  HistoryView.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct HistoryView: View {
	@State var historyType: HistoryType = .like
	@State var likes: [MemeResponse] = []
	@State var dislikes: [MemeResponse] = []
	@State private var isLoading: Bool = false
	@State private var selectedMeme: MemeResponse?
	
	private var currentOffset: Int {
		historyType == .like ? likes.count : dislikes.count
	}
	
	@ObservedObject var networkClient: NetworkClient<Empty, [MemeResponse]> = NetworkClient(
		request: ApiRequest(endpoint: .history(type: .like, limit: 5, offset: 0))
	)
	
	var body: some View {
		#if os(iOS)
		NavigationView {
			historyPage
				.navigationBarTitle(Text("My Memes"))
		}
		.navigationViewStyle(StackNavigationViewStyle())
		#elseif os(macOS)
		NavigationView {
			historyPage
				.navigationTitle("My Memes")
		}
		#endif
	}
	
	private var historyPage: some View {
		VStack {
			let memeView = selectedMeme != nil ? AnyView(MemeDetails(meme: selectedMeme!)) : AnyView(EmptyView())
			
			NavigationLink(
				destination: memeView,
				isActive: Binding(
					get: { selectedMeme != nil }, set: {if !$0 {selectedMeme = nil}}
				),
				label: { EmptyView() }
			)
			
			Picker(selection: $historyType, label: EmptyView()) {
				ForEach(HistoryType.allCases) {
					Text("\(String(describing: $0))")
						.tag($0)
				}
			}
			.onChange(of: historyType) { type in
				reset()
			}
			.padding()
			.pickerStyle(SegmentedPickerStyle())
			
			ScrollView(.vertical, showsIndicators: true) {
				LazyVStack {
					ForEach(historyType == .like ? likes : dislikes, id: \.id) { meme in
						HistoryRowView(
							meme: meme,
							memePresented: Binding(
								get: { selectedMeme != nil },
								set: {if !$0 {selectedMeme = nil}
								}
							)
						)
						.onTapGesture {
							selectedMeme = meme
						}
						.onAppear {
							if meme == (historyType == .like ? likes : dislikes).last {
								loadMoreMemes()
							}
						}
					}
					if isLoading {
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle())
					}
				}
				.frame(maxHeight: .infinity, alignment: .top)
			}
		}
		.onAppear {
			reset()
		}
		.onReceive(networkClient.$response.dropFirst()) { memes in
			guard let memes = memes else { return }
			
			if historyType == .like {
				likes.append(contentsOf: memes)
			} else {
				dislikes.append(contentsOf: memes)
			}
			
			isLoading = false
		}
	}
	
	private func reset() {
		networkClient.request = ApiRequest(endpoint: .history(type: historyType, limit: 5, offset: 0))
		likes = []
		dislikes = []
		networkClient.load()
	}
	
	private func loadMoreMemes() {
		isLoading = true
		networkClient.request = ApiRequest(endpoint: .history(type: historyType, limit: 20, offset: currentOffset))
		networkClient.load()
	}
}

struct HistoryView_Previews: PreviewProvider {
	static var previews: some View {
		HistoryView(
			historyType: .like,
			likes: [
				MemeResponse(
					id: "1234",
					url: URL(string: "https://i.redd.it/00rr8gg4spi61.jpg")!,
					upvotes: 1337,
					downvotes: 337
				)
			],
			dislikes: [],
			networkClient: NetworkClient()
		)
	}
}
