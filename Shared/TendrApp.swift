//
//  TendrApp.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI

@main
struct TendrApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
		
		#if os(macOS)
		Settings {
			PreferencesPage()
		}
		#endif
    }
}
