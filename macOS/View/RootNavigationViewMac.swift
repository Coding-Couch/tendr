//
//  RootNavigationView.swift
//  Tendr (macOS)
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct RootNavigationViewMac: View {
	@EnvironmentObject var authManager: AuthManager
	
	var body: some View {
		if !authManager.isAuthenticated {
			LandingPage()
				.transition(.slide)
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		} else {
			NavigationView {
				SideBarNavigationView()
					.transition(.slide)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			.toolbar {
				ToolbarItem(placement: .navigation) {
					Button(action: toggleSideBar) {
						Image(systemName: "sidebar.left")
					}
				}
			}
		}
	}
	
	private func toggleSideBar() {
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
	}
}

struct RootNavigationViewMac_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationViewMac()
			.environmentObject(MockAuthManager() as AuthManager)
    }
}
