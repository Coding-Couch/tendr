//
//  RootNavigationViewIOS.swift
//  Tendr (iOS)
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct RootNavigationViewIOS: View {
	@EnvironmentObject var authManager: AuthManager
	
    var body: some View {
		TabBarView()
			.fullScreenCover(
				isPresented: Binding(
					get: { !authManager.isAuthenticated },
					set: { _ in	}
				),
				content: { LoginPage() }
			)
    }
}

struct RootNavigationViewIOS_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationViewIOS()
			.environmentObject(MockAuthManager() as AuthManager)
    }
}
