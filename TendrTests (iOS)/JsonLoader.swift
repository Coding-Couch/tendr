//
//  File.swift
//  TendrTests (iOS)
//
//  Created by Brent Mifsud on 2021-02-20.
//

import Foundation

class JsonLoader {
	let bundle = Bundle.init(for: JsonLoader.self)

	func loadJson(fileName: String) throws -> Data {
		guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
			throw JsonLoaderError.fileNotFound
		}

		return try Data(contentsOf: url)
	}

	enum JsonLoaderError: Error {
		case fileNotFound
	}
}
