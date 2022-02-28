//
//  UserDefaultsExtension.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 18/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
    func value(forKey key: String) -> Any?
    func setValue(_ value: Any?, forKey key: String)
    func set(_ value: Bool, forKey key: String)
    func synchronize() -> Bool
    func set(_ value: AccessToken?, forKey key: String)
    func set(_ value: String?, forKey key: String)
    func token(forKey key: String) -> AccessToken?
    func string(forKey key: String) -> String?
}

extension UserDefaults: UserDefaultsProtocol {
    
    // MARK: - Setters
    
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
    
    func set(_ value: String?, forKey key: String) {
        self.setValue(value, forKey: key)
    }
	
    // MARK: - Getters
    
	func token(forKey key: String) -> AccessToken? {
		guard
			let data: Data = self.object(forKey: key) as? Data,
			let accessToken: AccessToken = try? JSONDecoder().decode(AccessToken.self, from: data)
			else { return nil }
		
		return accessToken
	}
    
    
    
}
