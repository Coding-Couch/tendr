//
//  MemeResponse.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation

/// Response body for a meme from Tendr
struct MemeResponse: Identifiable, Codable, Equatable {
	var id: String
	var url: URL
	var upvotes: Int
	var downvotes: Int
	
	init(id: String, url: URL, upvotes: Int, downvotes: Int) {
		self.id = id
		self.url = url
		self.upvotes = upvotes
		self.downvotes = downvotes
	}
}
