//
//  HistoryView.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct HistoryView: View {
	@State var historyType: HistoryType = .likes
    @ObservedObject var historyProvider: HistoryProvider = HistoryProvider(historyType: .likes)
    
	
    var body: some View {
		#if os(iOS)
		NavigationView {
			historyPage
				.navigationBarTitle(Text("Meme History"))
		}
		.navigationViewStyle(StackNavigationViewStyle())
		#elseif os(macOS)
		NavigationView {
			historyPage
		}
		#endif
    }
	
	private var historyPage: some View {
		VStack {
			Picker(selection: $historyType, label: EmptyView()) {
				ForEach(HistoryType.allCases) {
					Text("\($0.name)").tag($0)
				}
			}
			.pickerStyle(SegmentedPickerStyle())
			
			List {
                ForEach(historyProvider.memes, id: \.id) { meme in
                    NavigationLink(destination: Text("Number: \(meme.id)")) {
                        Text("Go To Number: \(meme.id)")
					}
				}
			}
		}
		.padding([.horizontal, .top])
	}
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
		HistoryView()
    }
}
