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
	
	#warning("TODO - Remove this if we get sign-in with apple working")
	var signupUUID: UUID? {
		willSet {
			defaults.set(newValue?.uuidString, forKey: AppStorageConstants.signupUUID)
		}
	}
	
	/// The auth token from Tendr API.
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
	
	/// Authorization Code from sign-in with apple
	var appleAuthCode: String? {
		willSet {
			defaults.set(newValue, forKey: AppStorageConstants.appleAuthCode)
		}
	}
	
	/// UserId from sign-in with apple
	var appleUserId: String? {
		willSet {
			defaults.set(newValue, forKey: AppStorageConstants.appleUserId)
		}
	}
	
	init() {
		if let uuid = defaults.string(forKey: AppStorageConstants.signupUUID) {
			signupUUID = UUID(uuidString: uuid)
		}
		
		authToken = defaults.string(forKey: AppStorageConstants.apiAuthToken)
		appleAuthCode = defaults.string(forKey: AppStorageConstants.appleAuthCode)
		appleUserId = defaults.string(forKey: AppStorageConstants.appleUserId)
		
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
		withAnimation {
			self.authToken = "12345"
		}
	}
	
	override func fetchAuthToken(with appleToken: String) {
		// Send apple auth token to api
		withAnimation {
			self.authToken = "12345"
		}
	}
}
