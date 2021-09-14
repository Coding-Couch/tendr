//
//  MemeResponseTest.swift
//  TendrTests (iOS)
//
//  Created by Brent Mifsud on 2021-02-20.
//

import XCTest
@testable import Tendr

class MemeResponseTest: XCTestCase {
    private let jsonLoader = JsonLoader()

    func testExample() throws {
        let data = try jsonLoader.loadJson(fileName: "MemeResponseArray")
        XCTAssertNoThrow(try JSONDecoder().decode([MemeResponse].self, from: data))
    }
}
