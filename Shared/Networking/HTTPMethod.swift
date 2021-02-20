//
//  HTTPMethod.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-19.
//

enum HTTPMethod: String, Codable {
	case options = "OPTIONS"
	case get = "GET"
	case head = "HEAD"
	case post = "POST"
	case put = "PUT"
	case patch = "PATCH"
	case delete = "DELETE"
	case trace = "TRACE"
	case connect = "CONNECT"
}
