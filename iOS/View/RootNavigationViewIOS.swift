//
//  RootNavigationViewIOS.swift
//  Tendr (iOS)
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct RootNavigationViewIOS: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showLogin: Bool = false

    var body: some View {
        TabBarView()
            .onReceive(authManager.$authToken, perform: { authToken in
                showLogin = authToken == nil
            })
            .fullScreenCover(
                isPresented: $showLogin,
                content: { LoginPage() }
            )
    }
}

struct RootNavigationViewIOS_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationViewIOS()
            .environmentObject(MockAuthManager() as AuthManager)
    }
}
