//
//  ApiRequest.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import Foundation


/// Simple Struct for generating URLSession Requests for the Tendr Api.
struct ApiRequest<Request: Codable> {
	var endpoint: Endpoint
	var headers: [String: String] = [:]
	var requestBody: Request?
	
	/// Convenience struct for creating `URLRequest`
	/// - Parameters:
	///   - endpoint: The Api `Endpoint` to use.
	///   - headers: The HTTP Headers
	///   - requestBody: The HTTP Request Body
	init(endpoint: Endpoint, headers: [String : String] = [:], requestBody: Request? = nil) {
		self.endpoint = endpoint
		self.headers = headers
		self.requestBody = requestBody
	}
	
	/// Initialize an `ApiRequest` with default headers.
	/// - Parameters:
	///   - endpoint: The Api `Endpoint` to use.
	///   - requestBody: The HTTP Request Body
	init(endpoint: Endpoint, requestBody: Request? = nil) {
		var headers = [String: String]()
		
		if let token = UserDefaults.standard.string(forKey: AppStorageConstants.apiAuthToken) {
			headers["Authorization"] = token
		}
		
		if let userId = UserDefaults.standard.string(forKey: AppStorageConstants.appleUserId) {
			headers["X-User-UUID"] = userId
		}
		
		self.init(endpoint: endpoint, headers: headers, requestBody: requestBody)
	}
	
	/// Produces a `URLRequest` to use with `URLSession`
	/// - Throws: `ApiRequestError`
	/// - Returns: `URLRequest`
	func createURLRequest() throws -> URLRequest {
		let urlString = endpoint.path
		
		guard var urlComponents = URLComponents(string: urlString) else {
			throw ApiRequestError.invalidUrl(url: urlString)
		}
		
		urlComponents.queryItems = endpoint.queryParms
		
		guard let url = urlComponents.url else {
			throw ApiRequestError.invalidUrl(url: String(describing: urlComponents))
		}
		
		var request = URLRequest(url: url)
		
		request.httpMethod = endpoint.httpMethod.rawValue
		
		for (key, value) in headers {
			request.setValue(value, forHTTPHeaderField: key)
		}
		
		if let requestBody = requestBody {
			do {
				request.httpBody = try JSONEncoder().encode(requestBody)
			} catch let EncodingError.invalidValue(value, context) {
				throw ApiRequestError.serialization(value: value, codingPath: context.codingPath)
			}
		}
		
		return request
	}
	
	/// Errors thrown by `ApiRequest`
	enum ApiRequestError: LocalizedError {
		case serialization(value: Any, codingPath: [CodingKey])
		case invalidUrl(url: String)
		
		var errorDescription: String? {
			switch self {
			case .invalidUrl(let url):
				return "The provided url: \(url) is invalid"
			case .serialization(let value, let codingPath):
				return """
				Failed to serialize request body.
				Value: \(String(describing: value))
				CodingPath: \(String(describing: codingPath))
				"""
			}
		}
	}
}
