//
//  ApiRequestTest.swift
//  TendrTests (iOS)
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation
import XCTest
@testable import Tendr

class ApiRequestTest: XCTestCase {
	let requestBody = MemeResponse(
		id: "1234",
		url: URL(string: "https://i.redd.it/66kprroymei61.png")!,
		fileType: .png,
		upvotes: 123,
		downvotes: 123
	)
	
	func test_defaultRequest() throws {
		let request = ApiRequest(endpoint: .memes(), requestBody: requestBody)
		XCTAssertNoThrow(try request.createURLRequest())
	}
}
