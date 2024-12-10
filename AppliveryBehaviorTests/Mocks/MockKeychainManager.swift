//
//  MockKeychainManager.swift
//  Applivery
//
//  Created by Fran Alarza on 10/12/24.
//

@testable import Applivery

class MockKeychainManager: KeychainAccessible {

    private var storage: [String: String] = [:]

    func store(_ password: String, for account: String) throws {
        storage[account] = password
    }

    func retrieve(for account: String) throws -> String {
        if let data = storage[account] {
            return data
        } else {
            throw KeychainError.itemNotFound
        }
    }

    func remove(for account: String) throws {
        storage.removeValue(forKey: account)
    }
}
