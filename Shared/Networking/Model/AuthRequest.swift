//
//  AuthRequest.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-20.
//

import Foundation

/// Request body for authentication with Tendr Api.
struct AuthRequest: Codable {
	var uuid: String
}
