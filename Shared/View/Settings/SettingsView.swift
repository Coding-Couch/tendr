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
		#if os(iOS) || os(watchOS) || os(tvOS)
		NavigationView {
			Form {
				mainView
					.navigationBarTitle(Text("Settings", comment: "Settings Page Title"))
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
		#elseif os(macOS)
		List {
			mainView
		}
		.frame(maxWidth: 600, maxHeight: 400)
		.navigationTitle(Text("Settings", comment: "Settings Page Title"))
		#endif
	}
	
	@ViewBuilder private var mainView: some View {
		Section(header: Text("User Preferences", comment: "User Preferences settings Section Label")) {
			Toggle(isOn: $nsfwEnabled) {
				Text("Show NSFW Memes (beta)", comment: "Show NSFW Settings Label")
			}
			
			if let userId = authManager.appleUserId {
				#if os(iOS) || os(watchOS) || os(tvOS)
				Button {
					let pasteboard = UIPasteboard.general
					pasteboard.string = userId
				} label: {
					VStack(alignment: .leading) {
						Text("Your UserId:")
							.foregroundColor(.label)
						Text(userId)
					}
				}
				#elseif os(macOS)
				HStack {
					Text("Your UserId:")
						.foregroundColor(.label)
					
					Text(userId)
					
					Spacer()
					
					Button {
						let pasteboard = NSPasteboard.general
						pasteboard.setString(userId, forType: .string)
					} label: {
						Image(systemName: "doc.on.doc")
					}
					
				}
				#endif
			}
		}
		
		Section(header: Text("About", comment: "About this app settings Section Label")) {
			#if os(iOS)
			NavigationLink(
				"About Us",
				destination: CreditsView()
					.padding()
					.navigationBarTitle("About Us", displayMode: .inline)
			)
			#endif
			
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
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
			.environmentObject(MockAuthManager())
	}
}
