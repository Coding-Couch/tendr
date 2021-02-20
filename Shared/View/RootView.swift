//
//  ContentView.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI

struct RootView: View {	
    var body: some View {
		#if os(macOS)
		RootNavigationViewMac()
		#elseif os(iOS)
		RootNavigationViewIOS()
		#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(MockAuthManager() as AuthManager)
    }
}
