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
			return NSLocalizedString("History", comment: "History Tab")
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
