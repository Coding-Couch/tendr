//
//  PreferencesPage.swift
//  Tendr (macOS)
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct PreferencesPage: View {
	
	@AppStorage(AppStorageConstants.nsfwEnabled) private var nsfwEnabled = false
	
	private var releaseVersion: String {
		return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
	}
	
    var body: some View {
		List {
			Section(header: Text("User Preferences", comment: "User Preferences settings Section Label")) {
				Toggle(isOn: $nsfwEnabled) {
					Text("Show NSFW Memes", comment: "Show NSFW Settings Label")
				}
			}
			
			Section(header: Text("About", comment: "About this app settings Section Label")) {
				HStack {
					Text("Version")
					Spacer()
					Text(releaseVersion)
				}
			}
		}
		.frame(width: 400, height: 400)
		.navigationTitle(Text("Settings", comment: "Settings Page Title"))
    }
}

struct PreferencesPage_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesPage()
    }
}
