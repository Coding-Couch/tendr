//
//  MemeAction.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

enum MemeAction: CaseIterable {
    case dislike
    case skip
    case like
    
    var icon: Image {
        switch self {
        case .dislike:
            return Image(systemName: "xmark")
        case .skip:
            return Image(systemName: "arrow.counterclockwise")
        case .like:
            return Image(systemName: "heart")
        }
    }
    
    var color: Color {
        switch self {
        case .dislike:
            return .red
        case .skip:
            return Color(.systemGray2)
        case .like:
            return .green
        }
    }
}
