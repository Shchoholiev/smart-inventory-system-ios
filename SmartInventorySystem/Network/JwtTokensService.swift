//
//  JwtTokensService.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import Foundation
import JWTDecode

class JwtTokensService {
    
    let accessTokenIdentifier = "accessToken"
    
    let refreshTokenIdentifier = "refreshToken"
    
    func storeTokensInKeychain(tokens: TokensModel) {
        GlobalUser.shared.setUserFromJwt(tokens.accessToken)
        storeTokenInKeychain(accessTokenIdentifier, tokens.accessToken)
        storeTokenInKeychain(refreshTokenIdentifier, tokens.refreshToken)
    }
    
    func clearTokensInKeychain() {
        removeItemFromKeychain(accessTokenIdentifier)
        removeItemFromKeychain(refreshTokenIdentifier)
    }
    
    func isExpired() -> Bool {
        let jwtTokens = getTokensFromKeychain();
        if let tokens = jwtTokens {
            do {
                let jwt = try decode(jwt: tokens.accessToken)
                let expirationDate = jwt.expiresAt
                let currentDate = getCurrentUTCDate()

                return expirationDate != nil && currentDate > expirationDate!
            } catch {
                print("Error decoding JWT token: \(error)")
            }
        }
        
        return true
    }
    
    private func getCurrentUTCDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let utcDateString = dateFormatter.string(from: Date())
        return dateFormatter.date(from: utcDateString)!
    }
    
    func getTokensFromKeychain() -> TokensModel? {
        let accessTokenValue = self.getTokenFromKeychain(accessTokenIdentifier);
        let refreshTokenValue = self.getTokenFromKeychain(refreshTokenIdentifier);
        
        if let accessToken = accessTokenValue,
           let refreshToken = refreshTokenValue {
            return TokensModel(accessToken: accessToken, refreshToken: refreshToken)
        }
        
        return nil
    }
    
    private func getTokenFromKeychain(_ identifier: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
            let data = result as? Data,
            let value = String(data: data, encoding: .utf8) {

            return value
        } else {
            return nil
        }
    }
    
    private func storeTokenInKeychain(_ identifier: String, _ value: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecValueData as String: value.data(using: .utf8)!
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            if status == errSecDuplicateItem {
                let updateQuery: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: identifier
                ]
                
                let attributes: [String: Any] = [
                    kSecValueData as String: value.data(using: .utf8)!
                ]
                
                let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
                if updateStatus != errSecSuccess {
                    print("Error updating value of: \"\(identifier)\" in Keychain")
                }
            } else {
                print("Error storing value of: \"\(identifier)\" in Keychain")
            }
        }
    }
    
    func removeItemFromKeychain(_ identifier: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecReturnAttributes as String: true
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Item removed successfully")
        } else if status == errSecItemNotFound {
            print("Item not found in Keychain")
        } else {
            print("Error removing item from Keychain: \(status)")
        }
    }
}
