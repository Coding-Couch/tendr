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

@MainActor class AuthManager: ObservableObject {
    private var defaults: UserDefaults = UserDefaults.standard
    private lazy var logger = Logger(subsystem: bundleId, category: "Authentication Errors")
    private lazy var client = NetworkClient()

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

    @Published var isLoading: Bool = false

    init() {
        authToken = defaults.string(forKey: AppStorageConstants.apiAuthToken)
        appleUserId = defaults.string(forKey: AppStorageConstants.appleUserId)
    }

    /// Fetch auth token from API
    /// - Parameter credential: Apple User Token
    func fetchAuthToken(with credential: String) async throws {
        appleUserId = credential

        isLoading = true

        defer {
            isLoading = false
        }

        _ = try await client
            .submitRequest(
                ApiRequest(endpoint: .auth, requestBody: AuthRequest(uuid: credential)),
                responseType: Empty.self
            )

        authToken = credential
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
    override func fetchAuthToken(with credential: String) async throws {
        withAnimation {
            self.authToken = credential
        }
    }
}
