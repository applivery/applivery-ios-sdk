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
	let userDefaults: UserDefaults
	
	func save(accessToken: AccessToken?) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(accessToken, forKey: kAccessTokenKey)
		userDefaults.synchronize()
	}
	
	func loadAccessToken() -> AccessToken? {
		let userDefaults = UserDefaults.standard
		let accessToken: AccessToken? = userDefaults.token(forKey: kAccessTokenKey)
		return accessToken
	}
}

extension UserDefaults {
	func set(_ value: AccessToken?, forKey key: String) {
		do {
			let data = try JSONEncoder().encode(value)
			self.set(data, forKey: key)
		} catch {
			logWarn("Could not encode value: \(String(describing: value))")
		}
	}
	
	func token(forKey key: String) -> AccessToken? {
		guard
			let data: Data = self.object(forKey: key) as? Data,
			let accessToken: AccessToken = try? JSONDecoder().decode(AccessToken.self, from: data)
			else { return nil }
		
		return accessToken
	}
}
