//
//  APIClient.swift
//  Applivery
//
//  Created by Fran Alarza on 27/11/24.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T
    func uploadVideo(localFileURL: URL, to destinationURL: URL) async throws
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    
    private lazy var decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
        return jsonDecoder
    }()

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let request = try endpoint.getURLRequest()
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        data.prettyPrintedJSON()
        
        switch httpResponse.statusCode {
        case 200...299:
            return try decoder.decode(T.self, from: data)
        default:
            throw APIError.statusCode(httpResponse.statusCode)
        }
    }
    
    func uploadVideo(localFileURL: URL, to destinationURL: URL) async throws {
        var request = URLRequest(url: destinationURL)
        request.httpMethod = "PUT"
        request.setValue("video/mp4", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.upload(for: request, fromFile: localFileURL)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            logInfo("Video uploaded successfully")
        default:
            throw APIError.statusCode(httpResponse.statusCode)
        }
        
        data.prettyPrintedJSON()
    }
}

extension Data {
    func prettyPrintedJSON() {
        if let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
           let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyJSONString = String(data: prettyPrintedData, encoding: .utf8) {
            print("- RESPONSE: \n \(prettyJSONString)")
        } else {
            print(String(data: self, encoding: .utf8) ?? "")
        }
    }
}
