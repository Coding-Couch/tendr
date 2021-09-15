//
//  MemeResponse.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation

/// Response body for a meme from Tendr
struct MemeResponse: Codable, Hashable {
    let currentOffset: Int
    let totalCount: Int
    let memes: [MemeDTO]
}

struct MemeDTO: Identifiable, Codable, Hashable {
    let id: String
    let url: URL
    let upvotes: Int
    let downvotes: Int
}
