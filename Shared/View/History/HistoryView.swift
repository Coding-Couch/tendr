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
	@State private var memePresented: Bool = false
	@State private var isLoading: Bool = false
	
	private var currentOffset: Int {
		historyType == .like ? likes.count : dislikes.count
	}
	
	@ObservedObject var historyProvider: NetworkClient<Empty, [MemeResponse]> = NetworkClient(
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
			Picker(selection: $historyType, label: EmptyView()) {
				ForEach(HistoryType.allCases) {
					Text("\(String(describing: $0))").tag($0)
				}
			}
			.padding()
			.pickerStyle(SegmentedPickerStyle())
			
			ScrollView(.vertical, showsIndicators: true) {
				LazyVStack {
					ForEach(historyType == .like ? likes.indices : dislikes.indices, id: \.self) { index in
						let meme = historyType == .like ? likes[index] : dislikes[index]
						
						NavigationLink(
							destination: Text("Meme Destination"),
							isActive: $memePresented,
							label: {
								HistoryRowView(meme: meme, memePresented: $memePresented)
									.onTapGesture {
										memePresented = true
									}
							}
						)
						.onAppear {
							if index == currentOffset - 3 {
								loadMoreMemes()
							}
						}
						
						if isLoading {
							ProgressView()
								.progressViewStyle(CircularProgressViewStyle())
						}
					}
				}
				.frame(maxHeight: .infinity, alignment: .top)
			}
		}
		.onAppear {
			historyProvider.load()
		}
		.onReceive(historyProvider.$response.dropFirst()) { memes in
			guard let memes = memes else { return }
			
			if historyType == .like {
				likes.append(contentsOf: memes)
			} else {
				dislikes.append(contentsOf: memes)
			}
			
			isLoading = false
		}
	}
	
	private func loadMoreMemes() {
		isLoading = true
		historyProvider.request = ApiRequest(endpoint: .history(type: historyType, limit: 20, offset: currentOffset))
		historyProvider.load()
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
			historyProvider: NetworkClient()
		)
	}
}
