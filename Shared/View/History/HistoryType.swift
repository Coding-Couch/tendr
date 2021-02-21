//
//  HistoryType.swift
//  Tendr
//
//  Created by Vince on 2021-02-20.
//

import Foundation

enum HistoryType: Int, CaseIterable, Identifiable {
    var id: Int {
        return rawValue
    }
    
    case likes
    case dislikes
    
    
    var name: String {
        switch self {
        case .likes:
            return NSLocalizedString("Liked Memes", comment: "History Page likes segment")
        case .dislikes:
            return NSLocalizedString("Disliked Memes", comment: "History Page dislikes segment")
        }
    }
}
