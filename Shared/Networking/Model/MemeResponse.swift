//
//  MemeResponse.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation

struct MemeResponse: Identifiable, Codable {
	var id: String
	var url: URL
	var fileType: FileType?
	var upvotes: Int
	var downvotes: Int
}


enum FileType: String, Codable {
	case mp4
	case gif
	case jpeg
	case png
}
