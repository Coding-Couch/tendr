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
					destination: HomeView(),
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
					destination: Text("History Page Not Implemented..."),
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
			
			Spacer()
			
			Button {
				authManager.logout()
			} label: {
				Text("Logout", comment: "Mac Sidebar Logout Button")
			}
			.buttonStyle(LargeButtonStyle(color: Color(.systemGray)))
			.frame(width: 150)
			.frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
			.padding()
		}
	}
}

struct SideBarNavigationView_Previews: PreviewProvider {
	static var previews: some View {
		SideBarNavigationView()
			.environmentObject(MockAuthManager())
	}
}
