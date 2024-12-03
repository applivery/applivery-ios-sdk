//
//  TokenData.swift
//  Applivery
//
//  Created by Fran Alarza on 3/12/24.
//


struct TokenData: Decodable {
    let token: String
}

struct DownloadToken: Decodable {
    let status: Bool
    let data: TokenData
}