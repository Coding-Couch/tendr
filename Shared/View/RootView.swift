//
//  ContentView.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI

struct RootView: View {

	@ObservedObject var authManager: AuthManager = {
		#if DEBUG
		return MockAuthManager()
		#else
		return AuthManager()
		#endif
	}()
	
    var body: some View {
		rootView
			.environmentObject(authManager)
    }
	
	@ViewBuilder var rootView: some View {
		#if os(macOS)
		RootNavigationViewMac()
		#elseif os(iOS)
		RootNavigationViewIOS()
		#endif
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(MockAuthManager() as AuthManager)
    }
}
