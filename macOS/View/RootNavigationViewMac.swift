//
//  RootNavigationView.swift
//  Tendr (macOS)
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct RootNavigationViewMac: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        if !authManager.isAuthenticated {
            LoginPage()
                .transition(.slide)
                .frame(minWidth: 400, maxWidth: 400, minHeight: 450, maxHeight: 450)
        } else {
            NavigationView {
                SideBarNavigationView()
                    .transition(.slide)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: toggleSideBar) {
                                Image(systemName: "sidebar.left")
                            }
                        }
                    }
            }
        }
    }

    private func toggleSideBar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct RootNavigationViewMac_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationViewMac()
            .environmentObject(MockAuthManager() as AuthManager)
    }
}
