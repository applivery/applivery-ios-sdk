//
//  SessionPersister.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 13/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation
import Security

let kAccessTokenKey = "ACCESS_TOKEN"
let kUserNameKey = "USER_NAME"

enum KeychainError: Error {
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    case itemNotFound
}


struct SessionPersister {
	let userDefaults: UserDefaultsProtocol
	
//	func save(accessToken: AccessToken?) {
//		self.userDefaults.set(accessToken, forKey: kAccessTokenKey)
//		_ = self.userDefaults.synchronize()
//	}
	
	func loadAccessToken() -> AccessToken? {
		let accessToken: AccessToken? = self.userDefaults.token(forKey: kAccessTokenKey)
		return accessToken
	}
    
    func saveUserName(userName: String) {
        self.userDefaults.setValue(userName, forKey: kUserNameKey)
    }
    
    func loadUserName() -> String {
        let userName: String = userDefaults.value(forKey: kUserNameKey) as? String ?? ""
        return userName
    }
    
    func removeUser() {
        userDefaults.setValue(nil, forKey: kUserNameKey)
    }
}
