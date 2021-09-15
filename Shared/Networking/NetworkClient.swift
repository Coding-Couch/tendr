//
//  NetworkClient.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-21.
//

import Foundation
import os

class NetworkClient {
    // MARK: - Error
    struct Error: LocalizedError {
        var errorDescription: String?
        var failureReason: String?
        var helpAnchor: String?
        var recoverySuggestion: String?
    }

    private lazy var logger = Logger(subsystem: bundleId, category: "NetworkClient")
    private lazy var session = URLSession.shared
    private lazy var decoder = JSONDecoder()

    // MARK: - Functions

    /// Submit a Tendr `ApiRequest` asynchronously
    /// - Returns: Codable Response Object
    func submitRequest<Request, Response: Codable>(_ request: ApiRequest<Request>, responseType: Response.Type) async throws -> Response {
        let request = try request.createURLRequest()
        let (data, urlResponse) = try await session.data(for: request)

        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            logger.critical("URLResponse could not be cast to HTTPURLResponse.\nDetails:\n\(urlResponse)")
            throw Self.Error(
                errorDescription: "URLResponse could not be cast to HTTPURLResponse",
                recoverySuggestion: "Please send a screenshot of this error to us."
            )
        }

        guard httpResponse.isSuccess else {
            logger.error("Bad HTTP Response: \(httpResponse)")
            throw Self.Error(
                errorDescription: "Tendr Servers Returned HTTP Code: \(httpResponse)"
            )
        }

        let response = try decoder.decode(Response.self, from: data)

        return response
    }
}
