//
//  AccessToken.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 10/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

struct AccessToken: Codable {
	let token: String?
}

extension AccessToken: Equatable {
	static func == (lhs: AccessToken, rhs: AccessToken) -> Bool {
		return lhs.token == rhs.token
	}
}

// MARK: - Builders
extension AccessToken {
	static func parse(from json: JSON) -> AccessToken {
		return AccessToken(
			token: json["bearer"]?.toString()
		)
	}
}
