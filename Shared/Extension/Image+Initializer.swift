//
//  Image+Initializer.swift
//  Tendr
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

extension Image {
    init?(data: Data) {
        #if os(iOS) || os(watchOS) || os(tvOS)
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
        #elseif os(macOS)
        if let nsImage = NSImage(data: data) {
            self.init(nsImage: nsImage)
        } else {
            return nil
        }
        #else
        return nil
        #endif
    }
}
