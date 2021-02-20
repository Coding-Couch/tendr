//
//  Endpoint.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation

enum Endpoint {	
	static let baseUrl = "http://34.95.9.213/api/1/"
	
	/// Api Endpoint to get memes. With Paging.
	/// - Parameters:
	///   - limit: The number of memes to return
	///   - offset: The meme to start fetching from. e.g. offset 5 would return the 6th meme.
	case memes(limit: Int?, offset: Int?)
	
	/// Api Endpoint to get like/dislike history. With Paging.
	/// - Parameters:
	///   - limit: The number of memes to return
	///   - offset: The meme to start fetching from. e.g. offset 5 would return the 6th meme.
	case history(limit: Int?, offset: Int?)
	
	/// Api Endpoint to get like/dislike history. With Paging.
	/// - Parameters:
	///   - userId: The user credential from apple signin
	case signin(userId: String)
	
	var path: String {
		switch self {
		case .memes:
			return Self.baseUrl + "memes"
		case .history:
			return Self.baseUrl + "memes/history"
		case .signin:
			return Self.baseUrl + "signin"
		}
	}
	
	var queryParms: [URLQueryItem] {
		var parms = [URLQueryItem]()
		
		switch self {
		case .memes(let limit, let offset):
			if let limit = limit {
				parms.append(URLQueryItem(name: "limit", value: "\(limit)"))
			}
			
			if let offset = offset {
				parms.append(URLQueryItem(name: "offset", value: "\(offset)"))
			}
		case .history(let limit, let offset):
			if let limit = limit {
				parms.append(URLQueryItem(name: "limit", value: "\(limit)"))
			}
			
			if let offset = offset {
				parms.append(URLQueryItem(name: "offset", value: "\(offset)"))
			}
			
		case .signin:
			return parms
		}
		
		return parms
	}
	
	var httpMethod: HTTPMethod {
		switch self {
		case .memes:
			return .get
		case .history:
			return .get
		case .signin:
			return .post
		}
	}
}

enum MemeSortType: String {
	case new
	case top
}
