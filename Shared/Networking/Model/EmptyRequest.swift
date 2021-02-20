//
//  EmptyRequest.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation

/// Used to satisfy generic type for an `ApiRequest` that has no request body (GET requests for example)
struct EmptyRequest: Codable {}
