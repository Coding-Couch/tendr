//
//  Color+MacOS.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

public extension Color {
    static let lightText = Color(NSColor.selectedTextColor)
    static let darkText = Color(NSColor.textColor)

    static let label = Color(NSColor.labelColor)
    static let secondaryLabel = Color(NSColor.secondaryLabelColor)
    static let tertiaryLabel = Color(NSColor.tertiaryLabelColor)
    static let quaternaryLabel = Color(NSColor.quaternaryLabelColor)

    static let systemBackground = Color(NSColor.windowBackgroundColor)
    static let secondarySystemBackground = Color(NSColor.controlBackgroundColor)
    static let tertiarySystemBackground = Color(NSColor.textBackgroundColor)

    static let grayLight = Color(NSColor.systemGray)

    // There are more..
}
