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
		NavigationView {
			if authManager.isAuthenticated {
				SideBarNavigationView()
					.transition(.slide)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				LoginPage()
					.transition(.slide)
					.frame(maxWidth: 400, maxHeight: .infinity, alignment: .center)
			}
			
			if authManager.isAuthenticated {
				CreditsView()
					.frame(maxWidth: 800, maxHeight: .infinity, alignment: .center)
			}
		}
		.toolbar {
			ToolbarItem(placement: .navigation) {
				Button(action: toggleSideBar) {
					Image(systemName: "sidebar.left")
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
