//
//  File.swift
//  Applivery
//
//  Created by Fran Alarza on 27/11/24.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension Endpoint {
    func getURLRequest() throws -> URLRequest {
        let url = try makeURL(from: self)
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.httpBody = makeBody(from: self.body)
        
        if let headers = self.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.debug()
        return request
    }
    
    private func makeBody(from params: [String: Any]?) -> Data? {
        guard let params, !params.isEmpty else { return nil }
        
        return try? JSONSerialization.data(withJSONObject: params)
    }
    
    private func makeURL(from endpoint: Endpoint) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = endpoint.host
        components.path = endpoint.path
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        return url
    }
}

extension URLRequest {
    func debug() {
        var safeHeaders = [String: String]()
        
        if let headers = self.allHTTPHeaderFields {
            for (key, value) in headers {
                if key == "Authorization" || key == "x-installation-token" {
                    safeHeaders[key] = "*********"
                } else {
                    safeHeaders[key] = value
                }
            }
        }
        
        logInfo("""
                - METHOD: \(self.httpMethod ?? "")
                - URL: \(String(describing: self.url))
                - HEADERS: \(safeHeaders)
                - BODY: \(String(data: self.httpBody ?? Data(), encoding: .utf8) ?? "")
                """)
    }
}


