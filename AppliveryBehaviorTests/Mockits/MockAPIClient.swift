//
//  MockAPIClient.swift
//  Applivery
//
//  Created by Fran Alarza on 3/12/24.
//

import Foundation
@testable import Applivery

class MockAPIClient: APIClientProtocol {
    var fetchHandler: ((Endpoint) async throws -> Any)?
    var uploadVideoHandler: ((URL, URL) async throws -> Void)?

    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        if let result = try await fetchHandler?(endpoint) as? T {
            return result
        } else {
            throw APIError.invalidResponse
        }
    }

    func uploadVideo(localFileURL: URL, to destinationURL: URL) async throws {
        if let handler = uploadVideoHandler {
            try await handler(localFileURL, destinationURL)
        } else {
            print("Mock upload successful")
        }
    }
}
