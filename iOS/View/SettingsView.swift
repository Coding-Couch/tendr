//
//  SettingsView.swift
//  Shared
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject private var authManager: AuthManager
	@AppStorage(AppStorageConstants.nsfwEnabled) var nsfwEnabled = false
	
	private var releaseVersion: String {
		return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
	}
	
	var body: some View {
		Form {
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
			
			Button {
				authManager.logout()
			} label: {
				HStack {
					Image(systemName: "power")
					Text("Logout", comment: "iOS Settings Logout Button")
				}
				.foregroundColor(.label)
			}
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
			.environmentObject(MockAuthManager())
	}
}
