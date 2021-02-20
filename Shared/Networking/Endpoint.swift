//
//  Endpoint.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation

enum Endpoint {	
	static let baseUrl = "http://34.95.9.213/api/1/"
	
	case memes(sorted: MemeSortType? = nil)
	
	var path: String {
		switch self {
		case let .memes(sorted):
			let path = Self.baseUrl + "memes"
			
			if let sorted = sorted {
				return path + "?sort=\(sorted.rawValue)"
			} else {
				return path
			}
		}
	}
	
	var queryParms: [URLQueryItem] {
		var parms = [URLQueryItem]()
		
		switch self {
		case .memes(let sorted):
			if let sorted = sorted {
				parms.append(URLQueryItem(name: "sort", value: sorted.rawValue))
			}
		}
		
		return parms
	}
	
	var httpMethod: HTTPMethod {
		switch self {
		case .memes:
			return .get
		}
	}
}

enum MemeSortType: String {
	case new
	case top
}
