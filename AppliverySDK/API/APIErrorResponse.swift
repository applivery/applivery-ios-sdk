//
//  APIErrorResponse.swift
//  Applivery
//
//  Created by Fran Alarza on 28/11/24.
//


struct APIErrorResponse: Decodable {
    let status: Bool
    let error: APIErrorDetail
}

struct APIErrorDetail: Decodable {
    let message: String
    let code: Int
}