//
//  KeychainHelper.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import Security
import Foundation
import RxSwift
 
protocol KeychainHelperType {
    func savePassword(password: String)
    func retrievePassword() -> String?
    func deletePassword() 
}

final class KeychainHelper: KeychainHelperType {
    
    private static let service = "JobsityTVService"
    private static let account = "JobsityTVAccount"
    
    static let shared = KeychainHelper()
    
    func savePassword(password: String) {
        guard let data = password.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainHelper.service,
            kSecAttrAccount as String: KeychainHelper.account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return }
    }
    
    func retrievePassword() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainHelper.service,
            kSecAttrAccount as String: KeychainHelper.account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let retrievedData = dataTypeRef as? Data else { return nil }
        
        return String(data: retrievedData, encoding: .utf8)
    }
    
    func deletePassword() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainHelper.service,
            kSecAttrAccount as String: KeychainHelper.account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { return }
    }
}
