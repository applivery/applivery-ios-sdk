//
//  User.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 19/03/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation

struct User {
	let email: String
	let firstName: String?
	let lastName: String?
	let tags: [String]?
	
	func log() {
		logInfo("Binding user \(email)")
		if let firstName = firstName {
			logInfo(" - \(firstName)")
		}
		if let lastName = lastName {
			logInfo(" - \(lastName)")
		}
		if let tags = tags {
			logInfo(" - TAGS: \(tags)")
		}
	}
}
