//
//  TabBarView.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedTab: Tab = .home
    
    /// Tab enum to represent each of the tabs in the TabBar
    enum Tab: CustomStringConvertible {
        case history
        case popular
        case home
        case settings
        
        /// Text description for the tab
        var description: String {
            switch self {
            case .history:
                return NSLocalizedString("History", comment: "History Tab")
            case .popular:
                return NSLocalizedString("Popular", comment: "Popular Tab")
            case .home:
                return NSLocalizedString("Home", comment: "Home Tab")
            case .settings:
                return NSLocalizedString("Settings", comment: "Settings Tab")
            }
        }
        
        /// Image for the tab
        var icon: Image {
            switch self {
            case .history:
                return Image(systemName: "clock")
            case .popular:
                return Image(systemName: "crown")
            case .home:
                return Image(systemName: "rectangle.stack.person.crop")
            case .settings:
                return Image(systemName: "gearshape")
            }
        }
        
        /// Tab item for the given tab
        @ViewBuilder var tabView: some View {
            self.icon
            Text(String(describing: self))
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab Content 1")
                .tabItem {
                    Tab.history.tabView
                }
                .tag(Tab.history)
            Text("Tab Content 2")
                .tabItem {
                    Tab.popular.tabView
                }
                .tag(Tab.popular)
            HomeView()
                .tabItem {
                    Tab.home.tabView
                }
                .tag(Tab.home)
            SettingsView()
                .tabItem {
                    Tab.settings.tabView
                }
                .tag(Tab.settings)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
