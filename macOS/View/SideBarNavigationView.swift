//
//  SideBarNavigationView.swift
//  Tendr (macOS)
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct SideBarNavigationView: View {
	@State var selectedView: AppSection = .home
	
    var body: some View {
		NavigationView {
			List {
				NavigationLink(
					"Tab Content 1",
					destination: Text("Tab Content 1"),
					isActive: Binding(
						get: { selectedView == .history },
						set: {
							if $0 == true {
								selectedView = .history
							}
						}
					)
				)
				
				NavigationLink(
					"Tab Content 2",
					destination: Text("Tab Content 2"),
					isActive: Binding(
						get: { selectedView == .popular },
						set: {
							if $0 == true {
								selectedView = .popular
							}
						}
					)
				)
				
				NavigationLink(
					"Tab Content 1",
					destination: HomeView(),
					isActive: Binding(
						get: { selectedView == .home },
						set: {
							if $0 == true {
								selectedView = .home
							}
						}
					)
				)
			}
		}
    }
}

struct SideBarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarNavigationView()
    }
}
