//
//  AlertContent.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-03-01.
//

import Foundation
import SwiftUI

struct AlertContent: Identifiable {
	var id: UUID = UUID()
	var title: String
	var message: String?
	
	var standardMessage: Text? {
		guard let message = message else { return nil }
		
		return Text("""
		Please send us a screenshot of this alert!
		Time Occured: \(Date())
		Error Details:
		\(message)
		""")
	}
}
