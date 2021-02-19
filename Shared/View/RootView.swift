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
		if !authManager.isAuthenticated {
			LandingPage()
		} else {
			NavigationView {
				Text("Hello World")
			}
//			.navigationBarTitle("Tendr")
			.navigationTitle("Tendr")
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(MockAuthManager() as AuthManager)
    }
}
