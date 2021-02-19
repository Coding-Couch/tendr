//
//  AuthManager.swift
//  Tendr (iOS)
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation
import SwiftUI

class AuthManager: ObservableObject {
	private var defaults = UserDefaults.standard
	
	@Published var isAuthenticated: Bool
	
	var authToken: String? {
		willSet {
			defaults.set(newValue, forKey: AppStorageConstants.apiAuthToken)
		}
		
		didSet {
			if authToken != nil {
				isAuthenticated = true
			} else {
				isAuthenticated = false
			}
		}
	}
	
	init() {
		authToken = defaults.string(forKey: AppStorageConstants.apiAuthToken)
		
		if authToken != nil {
			isAuthenticated = true
		} else {
			isAuthenticated = false
		}
	}
	
	func authenticate(authToken: String) {
		// Use network manager to send auth token to api
		// When we get an auth token back from api, save it to user defaults
	}
	
	func logout() {
		self.authToken = nil
	}
}

class MockAuthManager: AuthManager {
	override func authenticate(authToken: String) {
		self.authToken = "1234567"
	}
}
