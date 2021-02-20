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
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			}
			
			if !authManager.isAuthenticated {
				CreditsView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				SideBarNavigationView()
					.transition(.slide)
					.frame(minWidth: 300, maxWidth: .infinity)
			}
		}
	}
}

struct RootNavigationViewMac_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationViewMac()
			.environmentObject(MockAuthManager() as AuthManager)
    }
}
