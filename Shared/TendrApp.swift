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
		.commands {
			CommandGroup(after: CommandGroupPlacement.appVisibility) {
				Divider()
				
				Button {
					authManager.logout()
				} label: {
					Text("Logout")
				}
				.keyboardShortcut(KeyEquivalent("l"), modifiers: [.command, .control])
			}
		}
		
		#if os(macOS)
		Settings {
			PreferencesPage()
		}
		#endif
    }
}
