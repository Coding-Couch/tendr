//
//  ImageLoaderTest.swift
//
//
//  Created by Brent Mifsud on 2020-10-29.
//

import Combine
import Foundation
@testable import Tendr
import XCTest

class ImageLoaderTest: XCTestCase {
	private let url = URL(string: "https://specials-images.forbesimg.com/imageserve/5dfead704e2917000783aada/960x0.jpg")

	private var cancellable: AnyCancellable?

	private var sut: ImageLoader!

	func testImageLoad() throws {
		let exp = expectation(description: "Wait for image download")

		let sut = ImageLoader(url: url!)

		cancellable = sut.$image
			.receive(on: RunLoop.main)
			.sink { image in
				if image != nil {
					exp.fulfill()
				}
			}

		sut.load()

		waitForExpectations(timeout: 10)
	}
}
