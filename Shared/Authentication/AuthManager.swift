//
//  AuthManager.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation
import SwiftUI
import Combine
import os

class AuthManager: ObservableObject {
    private var defaults = UserDefaults.standard
    private var logger: Logger = Logger(subsystem: bundleId, category: "Authentication Errors")

    var isAuthenticated: Bool {
        authToken != nil
    }

    /// The persisted auth token from the Tendr Api
    @Published var authToken: String? {
        willSet {
            defaults.set(newValue, forKey: AppStorageConstants.apiAuthToken)
        }
    }

    /// The persisted Sign in with apple user credential.
    @Published var appleUserId: String? {
        willSet {
            defaults.set(newValue, forKey: AppStorageConstants.appleUserId)
        }
    }

    init() {
        withAnimation {
            authToken = defaults.string(forKey: AppStorageConstants.apiAuthToken)
            appleUserId = defaults.string(forKey: AppStorageConstants.appleUserId)
        }
    }

    /// Submit an Auth Request using a network client.
    /// - Parameter client: `NetworkClient` to use for the request.
    func fetchAuthToken(with client: NetworkClient<AuthRequest, Empty>) {
        client.load()
    }

    /// Clear the users persisted session.
    func logout() {
        withAnimation {
            authToken = nil
            appleUserId = nil
        }
    }
}

class MockAuthManager: AuthManager {
    override func fetchAuthToken(with client: NetworkClient<AuthRequest, Empty>) {
        withAnimation {
            self.authToken = self.appleUserId
        }
    }
}
