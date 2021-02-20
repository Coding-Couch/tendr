//
//  ContentView.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI

struct RootView: View {
	@EnvironmentObject var authManager: AuthManager
	
    var body: some View {
		NavigationView {
			if !authManager.isAuthenticated {
				LandingPage()
					.transition(.slide)
			} else {
				TabBarView()
					.transition(.slide)
			}
		}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(MockAuthManager() as AuthManager)
    }
}
