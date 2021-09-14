//
//  ApiRequestTest.swift
//  TendrTests (iOS)
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Combine
import Foundation
import XCTest
@testable import Tendr

class ApiRequestTest: XCTestCase {
    var cancellable: AnyCancellable?

    let requestBody = MemeResponse(
        id: "1234",
        url: URL(string: "https://i.redd.it/66kprroymei61.png")!,
        upvotes: 123,
        downvotes: 123
    )

    func test_defaultRequest() throws {
        let request = ApiRequest(endpoint: .memes(limit: 5, offset: 0), requestBody: requestBody)
        XCTAssertNoThrow(try request.createURLRequest())
    }

    func test_apiRequest() throws {
        let request = ApiRequest<Tendr.Empty>(endpoint: .memes(limit: 5, offset: 0))

        let exp = expectation(description: "Wait for response")

        cancellable = URLSession.shared.dataTaskPublisher(for: try request.createURLRequest())
            .map(\.data)
            .decode(type: [MemeResponse].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail("Failed to decode response")
                    exp.fulfill()
                }
            } receiveValue: { (_) in
                exp.fulfill()
            }

        waitForExpectations(timeout: 15)
    }
}
