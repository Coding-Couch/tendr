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
			if !authManager.isAuthenticated {
				LandingPage()
					.transition(.slide)
			} else {
				Text("Hello World")
					.transition(.slide)
			}
			
			if !authManager.isAuthenticated {
				CreditsView()
			} else {
				EmptyView()
			}
		}
		.toolbar {
			ToolbarItem(placement: .navigation) {
				Button(action: toggleSidebar) {
					Image(systemName: "sidebar.left")
				}
			}
		}
	}
	
	private func toggleSidebar() {
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
	}
    
}

struct RootNavigationViewMac_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationViewMac()
			.environmentObject(MockAuthManager() as AuthManager)
    }
}
