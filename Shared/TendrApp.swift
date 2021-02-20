//
//  TendrApp.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI

@main
struct TendrApp: App {
	@ObservedObject var authManager: AuthManager
	
	init() {
		#if DEBUG
		authManager = MockAuthManager()
		#else
		authManager = AuthManager()
		#endif
	}
	
    var body: some Scene {
        WindowGroup {
            RootView()
				.environmentObject(authManager)
			
        }
		
		#if os(macOS)
		Settings {
			PreferencesPage()
		}
		#endif
    }
}
