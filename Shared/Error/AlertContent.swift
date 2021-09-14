//
//  AlertContent.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-03-01.
//

import Foundation
import SwiftUI

struct AlertContent: Identifiable {
    private(set) var id: UUID = UUID()
    var title: String
    var message: String?

    var standardMessage: Text? {
        guard let message = message else { return nil }
        return Text(L10n.Alerts.Error.standard("\(Date())", "\(message)"))
    }
}
