//
//  SessionPersister.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 13/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

let kAccessTokenKey = "ACCESS_TOKEN"

struct SessionPersister {
	let userDefaults: UserDefaultsProtocol
	
	func save(accessToken: AccessToken?) {
		self.userDefaults.set(accessToken, forKey: kAccessTokenKey)
		_ = self.userDefaults.synchronize()
	}
	
	func loadAccessToken() -> AccessToken? {
		let accessToken: AccessToken? = self.userDefaults.token(forKey: kAccessTokenKey)
		return accessToken
	}
}
