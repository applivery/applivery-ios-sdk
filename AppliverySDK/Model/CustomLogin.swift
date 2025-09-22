//
//  CustomLogin.swift
//  Applivery
//
//  Created by Fran Alarza on 1/8/25.
//

import Foundation

struct CustomLogin: Codable {
    let status: Bool
    let data: CustomLoginData
}

struct CustomLoginData: Codable {
    let bearer: String
    let member: Member
}

struct Member: Codable {
    let id: String
    let email: String
    let firstName: String?
    let lastName: String?
}
