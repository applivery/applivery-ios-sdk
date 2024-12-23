//
//  KeychainAccessible.swift
//  Applivery
//
//  Created by Fran Alarza on 10/12/24.
//

import Security
import Foundation

protocol KeychainAccessible {
    func store(_ data: String, for account: String) throws
    func retrieve(for account: String) throws -> String
    func remove(for account: String) throws
}

final class Keychain: KeychainAccessible {
    
    func store(_ data: String, for account: String) throws {
        guard let data = data.data(using: .utf8) else {
            throw KeychainError.unexpectedPasswordData
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        logInfo("Password stored for account \(account)")
    }
    
    func retrieve(for account: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &item
        )
        
        if status == errSecItemNotFound {
            throw KeychainError.itemNotFound
        } else if status == errSecSuccess {
            guard let data = item as? Data,
                  let password = String(data: data, encoding: .utf8) else {
                throw KeychainError.unexpectedPasswordData
            }
            logInfo("Retrieved password for account \(account)")
            return password
        } else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func remove(for account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
        logInfo("Removed \(account) from keychain.")
    }
}
