//
//  AppSection.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-20.
//

import Foundation
import SwiftUI

/// AppSection enum to represent each of the tabs in the TabBar
enum AppSection: CustomStringConvertible {
    case history
    case home
    case settings

    /// Text description for the tab
    var description: String {
        switch self {
        case .history:
            return L10n.TabBar.Tab.history
        case .home:
            return L10n.TabBar.Tab.home
        case .settings:
            return L10n.TabBar.Tab.settings
        }
    }

    /// Image for the tab
    var icon: Image {
        switch self {
        case .history:
            return Image(systemName: "clock")
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
