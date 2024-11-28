//
//  APIError.swift
//  Applivery
//
//  Created by Fran Alarza on 27/11/24.
//

import Foundation

enum APIError: Error {
    case networkError(Error)
    case decoding
    case invalidURL
    case invalidResponse
    case unathorizedResponse
    case statusCode(Int)
    case ottCheckTimeout
}
