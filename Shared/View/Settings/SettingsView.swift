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
                    .navigationBarTitle(Text(L10n.Settings.NavBar.title))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        #elseif os(macOS)
        List {
            mainView
        }
        .frame(maxWidth: 600, maxHeight: 400)
        .navigationTitle(Text(L10n.Settings.NavBar.title))
        #endif
    }

    @ViewBuilder private var mainView: some View {
        Section(header: Text(L10n.Settings.Section.userPreferences)) {
            Toggle(isOn: $nsfwEnabled) {
                Text(L10n.Settings.Row.nsfw)
            }

            if let userId = authManager.appleUserId {
                #if os(iOS) || os(watchOS) || os(tvOS)
                Button {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = userId
                } label: {
                    VStack(alignment: .leading) {
                        Text(L10n.Settings.Row.userID)
                            .foregroundColor(Color.label)
                        Text(userId)
                    }
                }
                #elseif os(macOS)
                HStack {
                    Text(L10n.Settings.Row.userID)
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
                L10n.Settings.Row.about,
                destination: CreditsView()
                    .padding()
                    .navigationBarTitle(L10n.Credits.NavBar.title, displayMode: .inline)
            )
            #endif

            HStack {
                Text(L10n.Settings.Row.version)
                Spacer()
                Text(releaseVersion)
            }

            Button {
                authManager.logout()
            } label: {
                HStack {
                    Image(systemName: "power")
                    Text(L10n.Settings.Row.logout)
                }
                .foregroundColor(Color.label)
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
