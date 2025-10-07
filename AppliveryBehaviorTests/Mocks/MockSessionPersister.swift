//
//  MockSessionPersister.swift
//  AppliverySDK
//
//  Created by Abigail Dominguez Morlans on 30/9/25.
//  Copyright © 2025 Applivery S.L. All rights reserved.
//

@testable import Applivery

class MockSessionPersister: SessionPersisterProtocol {
    var savedUserName: String?
    var didSaveUserName = false
    var userNameToLoad: String = ""
    var accessTokenToLoad: AccessToken? = nil

    func loadAccessToken() -> AccessToken? {
        return accessTokenToLoad
    }

    func saveUserName(userName: String) {
        didSaveUserName = true
        savedUserName = userName
    }

    func loadUserName() -> String {
        return userNameToLoad
    }

    func removeUser() {
        userNameToLoad = ""
        savedUserName = nil
    }
}
