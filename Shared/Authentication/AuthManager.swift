//
//  AuthManager.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation
import SwiftUI

class AuthManager: ObservableObject {
	private var defaults = UserDefaults.standard
	
	/// Publish the authentication state of the app.
	@Published var isAuthenticated: Bool = false
	
	/// The persisted auth token from the Tendr Api
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
	
	/// The persisted Sign in with apple user credential.
	var appleUserId: String? {
		willSet {
			defaults.set(newValue, forKey: AppStorageConstants.appleUserId)
		}
	}
	
	init() {
		authToken = defaults.string(forKey: AppStorageConstants.apiAuthToken)
		appleUserId = defaults.string(forKey: AppStorageConstants.appleUserId)
		
		
		withAnimation {
			if authToken != nil {
				isAuthenticated = true
			} else {
				isAuthenticated = false
			}
		}
	}
	
	/// Retrieve an auth token for Tendr Api by sending your apple user credential.
	/// - Parameter appleUserId: user credential from `ASAuthorizationAppleIDCredential`
	func fetchAuthToken(with appleUserId: String) {
		print("Not Implemented")
	}
	
	/// Clear the users persisted session.
	func logout() {
		defaults.removeObject(forKey: AppStorageConstants.apiAuthToken)
		defaults.removeObject(forKey: AppStorageConstants.appleUserId)
		self.isAuthenticated = false
	}
}

class MockAuthManager: AuthManager {
	override func fetchAuthToken(with appleUserId: String) {
		// Send apple auth token to api
		withAnimation {
			self.authToken = "1234567890"
		}
	}
}
