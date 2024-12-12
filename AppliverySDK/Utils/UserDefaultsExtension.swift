//
//  UserDefaultsExtension.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 18/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

extension UserDefaults {
	func set(_ value: AccessToken?, forKey key: String) {
		guard let token = value else {
			return self.removeObject(forKey: key)
		}
		
		do {
			let data = try JSONEncoder().encode(token)
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
