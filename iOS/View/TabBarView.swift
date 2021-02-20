//
//  TabBarView.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedTab: AppSection = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab Content 1")
                .tabItem {
					AppSection.history.tabView
                }
                .tag(AppSection.history)
            Text("Tab Content 2")
                .tabItem {
					AppSection.popular.tabView
                }
                .tag(AppSection.popular)
            HomeView()
                .tabItem {
					AppSection.home.tabView
                }
                .tag(AppSection.home)
            SettingsView()
                .tabItem {
					AppSection.settings.tabView
                }
                .tag(AppSection.settings)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
