//
//  ContentView.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI

struct RootView: View {
	@EnvironmentObject var authManager: AuthManager
	
    var body: some View {
		#if os(macOS)
		navigationViewMac {
			Group {
				rootContent
				CreditsView()
			}
		}
		#elseif os(iOS)
		navigationViewiOS {
			rootContent
		}
		#endif
    }
	
	@ViewBuilder private var rootContent: some View {
		if !authManager.isAuthenticated {
			LandingPage()
				.transition(.slide)
		} else {
			Text("Hello World")
				.transition(.slide)
		}
	}
	
	#if os(iOS)
	@ViewBuilder private var hubView: some View {
		Text("Hub")
			.navigationBarHidden(true)
	}
	#elseif os(macOS)
	@ViewBuilder private var hubViewMacOS: some View {
		VStack {
			NavigationLink(destination: Text("History")) {
				Text("Page 1")
			}
			NavigationLink(destination: Text("Memes")) {
				Text("Page 2")
			}
			NavigationLink(destination: Text("Settings")) {
				Text("Page 3")
			}
		}
	}
	#endif
	
	#if os(iOS)
	func navigationViewiOS<Content: View>(content: () -> Content) -> some View {
		NavigationView {
			content()
		}
	}
	#endif
	
	#if os(macOS)
	func navigationViewMac<Content: View>(content: () -> Content) -> some View {
		NavigationView {
			content()
		}
		.toolbar {
			ToolbarItem(placement: .navigation) {
				Button(action: toggleSidebar) {
					Image(systemName: "sidebar.left")
				}
			}
		}
	}
	
	func toggleSidebar() {
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
	}
	#endif
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(MockAuthManager() as AuthManager)
    }
}
