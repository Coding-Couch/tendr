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
	
	var signupUUID: UUID? {
		willSet {
			defaults.set(newValue, forKey: AppStorageConstants.signupUUID)
		}
	}
	
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
	
	var appleAuthToken: String? {
		willSet {
			defaults.set(newValue, forKey: AppStorageConstants.appleAuthToken)
		}
	}
	
	init() {
		if let defaultValue = defaults.value(forKey: AppStorageConstants.signupUUID),
		   let uuid = defaultValue as? UUID {
			signupUUID = uuid
		} else {
			signupUUID = nil
		}
		
		authToken = defaults.string(forKey: AppStorageConstants.apiAuthToken)
		appleAuthToken = defaults.string(forKey: AppStorageConstants.appleAuthToken)
		
		if authToken != nil {
			isAuthenticated = true
		} else {
			isAuthenticated = false
		}
	}
	
	func fetchAuthToken(with uuid: UUID) {
		// Send UUID to our api to recieve authToken
	}
	
	func fetchAuthToken(with appleToken: String) {
		// Send apple auth token to api
	}
	
	func logout() {
		self.authToken = nil
	}
}

class MockAuthManager: AuthManager {
	override func fetchAuthToken(with uuid: UUID) {
		self.authToken = "12345"
	}
	
	override func fetchAuthToken(with appleToken: String) {
		// Send apple auth token to api
		self.authToken = "12345"
	}
}
