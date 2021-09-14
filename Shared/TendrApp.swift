//
//  TendrApp.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI

@main
struct TendrApp: App {
    @StateObject private var authManager: AuthManager = {
        #if DEBUG
        return MockAuthManager()
        #else
        return AuthManager()
        #endif
    }()

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
                    Text(L10n.Settings.Row.logout)
                }
                .keyboardShortcut(KeyEquivalent("l"), modifiers: [.command, .control])
            }

            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                VStack {
                    NavigationLink(
                        L10n.Settings.Section.about,
                        destination: VStack {
                            CreditsView()
                                .frame(
                                    minWidth: 400,
                                    idealWidth: 400,
                                    maxWidth: .infinity,
                                    minHeight: 400,
                                    idealHeight: 450,
                                    maxHeight: .infinity
                                )
                        }
                        .padding()
                    )
                }
            }
        }

        #if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(authManager)
        }
        #endif
    }
}
