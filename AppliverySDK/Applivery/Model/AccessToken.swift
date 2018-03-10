//
//  AccessToken.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 10/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

struct AccessToken {
	let token: String
	let expirationDate: Date
}

extension AccessToken: Equatable {
	static func == (lhs: AccessToken, rhs: AccessToken) -> Bool {
		return lhs.token == rhs.token && lhs.expirationDate == rhs.expirationDate
	}
}

// MARK: - Builders
extension AccessToken {
	static func parse(from json: JSON) -> AccessToken {
		return AccessToken(
			token: json["accessToken"]?.toString() ?? "",
			expirationDate: json["expirationDate"]?.toDate() ?? Date.today()
		)
	}
}
