//
//  SessionPersister.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 13/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

let kAccessTokenKey = "ACCESS_TOKEN"
let kFeedbackEmail = "FEEDBACK_EMAIL"

struct SessionPersister {
	let userDefaults: UserDefaultsProtocol
	
	func save(accessToken: AccessToken?) {
		self.userDefaults.set(accessToken, forKey: kAccessTokenKey)
	}
	
	func loadAccessToken() -> AccessToken? {
		self.userDefaults.token(forKey: kAccessTokenKey)
	}
    
    func save(email: String?) {
        self.userDefaults.set(email, forKey: kFeedbackEmail)
    }
    
    func loadEmail() -> String? {
        self.userDefaults.string(forKey: kFeedbackEmail)
    }
}
