//
//  HistoryView.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct HistoryView: View {
	@State var historyType: HistoryType = .like
	
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
				.frame(minWidth: 360)
				.navigationTitle("My Memes")
		}
		#endif
	}
	
	private var historyPage: some View {
		VStack {
			Picker(selection: $historyType, label: EmptyView()) {
				ForEach(HistoryType.allCases) {
					Text("\(String(describing: $0))")
						.tag($0)
				}
			}
			.padding()
			.pickerStyle(SegmentedPickerStyle())
			
			switch historyType {
			case .like:
				MemeHistoryList(historyType: .like)
			case .dislike:
				MemeHistoryList(historyType: .dislike)
			}
			
			Spacer()
		}
	}
}

struct HistoryView_Previews: PreviewProvider {
	static var previews: some View {
		HistoryView(historyType: .like)
	}
}
