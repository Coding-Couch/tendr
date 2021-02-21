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
	case history(type: HistoryType?, limit: Int?, offset: Int?)
	
	/// Api Endpoint to get like/dislike history. With Paging.
	case auth
	
	/// Api Endpoint to like a meme.
	/// - Parameters:
	///	  - id: The Meme's Id
	case like(id: String)
	
	/// Api Endpoint to dislike a meme.
	/// - Parameters:
	///	  - id: The Meme's Id
	case dislike(id: String)
	
	var path: String {
		switch self {
		case .memes:
			return Self.baseUrl + "memes"
		case .history:
			return Self.baseUrl + "/user/memes"
		case .auth:
			return Self.baseUrl + "signin"
		case .like(let id):
			return Self.baseUrl + "memes/\(id)/up"
		case .dislike(let id):
			return Self.baseUrl + "memes/\(id)/down"
		}
	}
	
	var queryParms: [URLQueryItem]? {
		var parms: [URLQueryItem] = []
		
		switch self {
		case .memes(let limit, let offset):
			if let limit = limit {
				parms.append(URLQueryItem(name: "limit", value: "\(limit)"))
			}
			
			if let offset = offset {
				parms.append(URLQueryItem(name: "offset", value: "\(offset)"))
			}
		case .history(let type, let limit, let offset):
			if let limit = limit {
				parms.append(URLQueryItem(name: "limit", value: "\(limit)"))
			}
			
			if let offset = offset {
				parms.append(URLQueryItem(name: "offset", value: "\(offset)"))
			}
			
			if let type = type {
				parms.append(URLQueryItem(name: "type", value: type.rawValue))
			}
		case .auth,
			 .like,
			 .dislike:
			break
		}
		
		return parms.isEmpty ? nil : parms
	}
	
	var httpMethod: HTTPMethod {
		switch self {
		case .memes:
			return .get
		case .history:
			return .get
		case .auth:
			return .post
		case .like,
			 .dislike:
			return .post
		}
	}
}

enum HistoryType: String, CustomStringConvertible, Identifiable {
	var id: String {
		self.rawValue
	}
	
	case like
	case dislike
	
	var description: String {
		switch self {
		case .like:
			return "Liked Memes"
		case .dislike:
			return "Disliked Memes"
		}
	}
}
