//
//  SettingsView.swift
//  Shared
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(AppStorageConstants.nsfwEnabled) private var nsfwEnabled = false
	@EnvironmentObject private var authManager: AuthManager
    
    var body: some View {
		NavigationView {
			Form {
				Section(header: Text("User Preferences", comment: "User Preferences settings Section Label")) {
					Toggle(isOn: $nsfwEnabled) {
						Text("Show NSFW Memes (beta)", comment: "Show NSFW Settings Label")
					}
                    
                    Button {
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = authManager.authToken
                        print(pasteboard.string)
                    } label: {
                        Text(authManager.authToken ?? "No Token")
                    }

				}
				
				Section(header: Text("About", comment: "About this app settings Section Label")) {
					NavigationLink(
						"About Us",
						destination: CreditsView()
							.padding()
							.navigationBarTitle("About Us", displayMode: .inline)
					)
					
					HStack {
						Text("Version")
						Spacer()
						Text(releaseVersion)
					}
					
					Button {
						authManager.logout()
					} label: {
						HStack {
							Image(systemName: "power")
							Text("Logout", comment: "Settings View Logout Text")
						}
						.foregroundColor(.label)
					}
				}
			}
			.navigationBarTitle(Text("Settings", comment: "Settings Page Title"))
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
			.environmentObject(MockAuthManager())
    }
}
