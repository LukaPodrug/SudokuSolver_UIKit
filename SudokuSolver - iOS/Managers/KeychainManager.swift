//
//  KeychainManager.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 20.12.2023..
//

import Foundation
import Security

enum KeychainValid: Error {
    case valid
    case missing
    case invalid
}

class KeychainManager {
    static let shared: KeychainManager = KeychainManager()
    
    func save(service: String, account: String, token: Data) -> (keychainSaveValid: KeychainValid?, keychainSaveMessage: String?) {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: token as AnyObject
        ]
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            return (.invalid, "Error with saving keychain")
        }
        
        return (.valid, "Success")
    }
    
    func get(service: String, account: String) -> (keychainGetValid: KeychainValid?, keychainGetMessage: String?, keychainGetData: Data?) {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            return (.missing, "Keychain not found", nil)
        }
        
        guard status == errSecSuccess else {
            return (.invalid, "Error with getting keychain", nil)
        }
        
        return (.valid, "Success", result as? Data)
    }
    
    func remove(service: String, account: String) -> (keychainRemoveValid: KeychainValid?, keychainRemoveMessage: String?) {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            return (.invalid, "Error with removing keychain")
        }
        
        return (.valid, "Success")
    }
}
