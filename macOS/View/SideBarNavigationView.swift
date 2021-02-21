//
//  SideBarNavigationView.swift
//  Tendr (macOS)
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct SideBarNavigationView: View {
	@EnvironmentObject var authManager: AuthManager
	
	@State private var activeSection: AppSection = .home
	
	var body: some View {
		VStack {
			List {
				NavigationLink(
					destination:
						MemeSwipeView()
						.frame(minWidth: 400, idealWidth: 600, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity, alignment: .center),
					isActive: Binding(
						get: { activeSection == .home },
						set: { if $0 == true { activeSection = .home }}
					)
				) {
					HStack {
						AppSection.home.icon
						Text(String(describing: AppSection.home))
					}
				}
				
				NavigationLink(
					destination: HistoryView(),
					isActive: Binding(
						get: { activeSection == .history },
						set: { if $0 == true { activeSection = .history }}
					)
				) {
					HStack {
						AppSection.history.icon
						Text(String(describing: AppSection.history))
					}
				}
			}
		}
		.frame(minWidth: 150, idealWidth: 150, maxWidth: 200, minHeight: 600, idealHeight: 800, maxHeight: .infinity)
	}
}

struct SideBarNavigationView_Previews: PreviewProvider {
	static var previews: some View {
		SideBarNavigationView()
			.environmentObject(MockAuthManager())
	}
}
