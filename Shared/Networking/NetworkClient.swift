//
//  NetworkClient.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-21.
//

import Foundation
import Combine
import os

class NetworkClient<Request: Codable, Response: Codable>: ObservableObject {
	private var logger = Logger(subsystem: bundleId, category: "NetworkClient")
	
	@Published private(set) var response: Response?
	@Published private(set) var urlResponse: HTTPURLResponse?
	@Published private(set) var error: Error?
	@Published private(set) var isLoading: Bool = false
	
	private var cancellable: AnyCancellable?
	
	var request: ApiRequest<Request>?
	
	init(request: ApiRequest<Request>? = nil) {
		self.request = request
	}
	
	// MARK: - Functions
	
	/// Perform the currently provided request (if there is one).
	func load() {
		guard let request = request else {
			logger.error("load() method called before populating network client request.")
			return
		}
		
		guard let urlRequest = try? request.createURLRequest() else {
			logger.error("Failed to instantiate a URLRequest from: \(request)")
			return
		}

		cancellable?.cancel()
		
		cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
			.receive(on: RunLoop.main)
			.handleEvents(receiveOutput: { [weak self] _, urlResponse in
				guard let self = self else { return }
				
				guard let httpResponse = urlResponse as? HTTPURLResponse else {
					self.logger.error("URLResponse could not be cast to HTTPURLResponse")
					self.error = NetworkError(errorDescription: "URLResponse could not be cast to HTTPURLResponse")
					return
				}
				
				self.urlResponse = httpResponse
				
				guard httpResponse.isSuccess else {
					self.logger.error("Bad HTTP Response: \(httpResponse)")
					self.error = NetworkError(errorDescription: "Bad HTTPResponse: \(httpResponse)")
					return
				}
			})
			.map(\.data)
			.decode(type: Response?.self, decoder: JSONDecoder())
			.replaceError(with: nil)
			.assign(to: \.response, on: self)
	}
	
	/// Reset the network client.
	func clear() {
		self.cancellable?.cancel()
		self.cancellable = nil
		self.response = nil
		self.error = nil
		self.urlResponse = nil
		self.request = nil
	}
	
	// MARK: - Error
	
	/// `NetworkClient` Errors
	struct NetworkError: LocalizedError {
		var errorDescription: String?
		var failureReason: String?
		var helpAnchor: String?
		var recoverySuggestion: String?
	}
}
