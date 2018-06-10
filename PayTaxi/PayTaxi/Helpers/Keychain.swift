//
//  Keychain.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

enum KeychainError: Error {
    case noKeychainData
    case unexpectedKeychainData
    case unexpectedItemData
    case unhandledError(status: OSStatus)
}

class Keychain: NSObject {
    
    //MARK: - Variables
    /// ServiceName is used for the kSecAttrService property to uniquely identify this keychain accessor. If no service name is specified, Keychain will default to using the bundleIdentifier.
    private (set) public var serviceName: String
    
    /// AccessGroup is used for the kSecAttrAccessGroup property to identify which Keychain Access Group this entry belongs to. This allows you to use the Keychain with shared keychain access between different applications.
    private (set) public var accessGroup: String?
    
    //Default Keychain access
    public static let standard = Keychain()
    
    private static let defaultServiceName: String = {
        return Bundle.main.bundleIdentifier ?? "com.paytaxi.PayTaxi"
    }()
    
    private convenience override init() {
        self.init(serviceName: Keychain.defaultServiceName)
    }
    
    //MARK: - Init
    /// Create a custom instance of Keychain with a custom Service Name and optional custom access group.
    ///
    /// - parameter serviceName: The ServiceName for this instance. Used to uniquely identify all keys stored using this keychain wrapper instance.
    /// - parameter accessGroup: Optional unique AccessGroup for this instance. Use a matching AccessGroup between applications to allow shared keychain access.
    public init(serviceName: String, accessGroup: String? = nil) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }
    
    //MARK: - Keychain access query
    func keychainQuery(forKey key: String) -> [String: Any] {
        
        // Setup default access as generic password (rather than a certificate, internet password, etc)
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        
        // Uniquely identify this keychain accessor
        query[kSecAttrService as String] = serviceName as AnyObject?
        
        // Set the keychain access group if defined
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier: Data? = key.data(using: String.Encoding.utf8)
        
        query[kSecAttrGeneric as String] = encodedIdentifier as AnyObject?
        query[kSecAttrAccount as String] = encodedIdentifier as AnyObject?
        
        //Return Keychain Query
        return query
    }
    
    /// Remove all keychain data added throughout the app. This will only delete items matching the currnt ServiceName and AccessGroup if one is set.
    func clearKeyChain() throws {
        
        // Setup dictionary to access keychain and specify we are using a generic password (rather than a certificate, internet password, etc)
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        
        // Uniquely identify this keychain accessor
        query[kSecAttrService as String] = serviceName as AnyObject?
        
        // Set the keychain access group if defined
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        // Add a the new item to the keychain.
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
    }
    
    //MARK: - API Token
    func saveApiToken(_ token: String) throws {
        
        // Encode the token into an Data object.
        let encodedToken = token.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = getApiToken()
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedToken as AnyObject?
            
            //Build a query to find the item that matches the service, account and access group.
            let query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kApiToken)
            
            // Try to update the existing keychain item that matches the query.
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
        catch KeychainError.noKeychainData {
            
            //No password was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kApiToken)
            newItem[kSecValueData as String] = encodedToken as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    func getApiToken() throws -> String {
        
        //Build a query to find the item that matches the service, account and access group.
        var query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kApiToken)
        
        // Limit search results to one
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        // Specify we want SecAttrAccessible returned
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        // Specify we want Data/CFData returned
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noKeychainData }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the token string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let tokenData = existingItem[kSecValueData as String] as? Data,
            let token = String(data: tokenData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedKeychainData
        }
        
        return token
    }
    
    func deleteApiToken() throws {
        
        //Build a query to find the item that matches the service, account and access group.
        let query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kApiToken)
        
        // Delete the existing item from the keychain.
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    //MARK: - Auth Token
    func saveAuthToken(_ token: String) throws {
        
        // Encode the token into an Data object.
        let encodedToken = token.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = getAuthToken()
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedToken as AnyObject?
            
            //Build a query to find the item that matches the service, account and access group.
            let query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kAuthToken)
            
            // Try to update the existing keychain item that matches the query.
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
        catch KeychainError.noKeychainData {
            
            //No password was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kAuthToken)
            newItem[kSecValueData as String] = encodedToken as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    func getAuthToken() throws -> String {
        
        //Build a query to find the item that matches the service, account and access group.
        var query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kAuthToken)
        
        // Limit search results to one
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        // Specify we want SecAttrAccessible returned
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        // Specify we want Data/CFData returned
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noKeychainData }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the token string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let tokenData = existingItem[kSecValueData as String] as? Data,
            let token = String(data: tokenData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedKeychainData
        }
        
        return token
    }
    
    func deleteAuthToken() throws {
        
        //Build a query to find the item that matches the service, account and access group.
        let query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kAuthToken)
        
        // Delete the existing item from the keychain.
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    //MARK: - API Token
    func saveSessionId(_ sessionId: String) throws {
        
        // Encode the sessionid into an Data object.
        let encodedSessionId = sessionId.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = getSessionId()
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedSessionId as AnyObject?
            
            //Build a query to find the item that matches the service, account and access group.
            let query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kSessionId)
            
            // Try to update the existing keychain item that matches the query.
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
        catch KeychainError.noKeychainData {
            
            //No password was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kSessionId)
            newItem[kSecValueData as String] = encodedSessionId as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    func getSessionId() throws -> String {
        
        //Build a query to find the item that matches the service, account and access group.
        var query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kSessionId)
        
        // Limit search results to one
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        // Specify we want SecAttrAccessible returned
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        // Specify we want Data/CFData returned
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noKeychainData }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the token string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let tokenData = existingItem[kSecValueData as String] as? Data,
            let token = String(data: tokenData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedKeychainData
        }
        
        return token
    }
    
    func deleteSessionId() throws {
        
        //Build a query to find the item that matches the service, account and access group.
        let query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kSessionId)
        
        // Delete the existing item from the keychain.
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    //MARK: - User
    func saveUser(_ user: User) throws {
        
        // Encode the user into an Data object.
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: user)
        
        do {
            // Check for an existing item in the keychain.
            try _ = getUser()
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedUser as AnyObject?
            
            //Build a query to find the item that matches the service, account and access group.
            let query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kUser)
            
            // Try to update the existing keychain item that matches the query.
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
        catch KeychainError.noKeychainData {
            
            //No password was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kUser)
            newItem[kSecValueData as String] = encodedUser as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    func getUser() throws -> User? {
        
        //Build a query to find the item that matches the service, account and access group.
        var query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kUser)
        
        // Limit search results to one
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        // Specify we want SecAttrAccessible returned
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        // Specify we want Data/CFData returned
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noKeychainData }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the token string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let userData = existingItem[kSecValueData as String] as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User
            else {
                throw KeychainError.unexpectedKeychainData
        }
        
        return user
    }
    
    func deleteUser() throws {
        
        //Build a query to find the item that matches the service, account and access group.
        let query = self.keychainQuery(forKey: GlobalConstants.KeyChainConstants.kUser)
        
        // Delete the existing item from the keychain.
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
}

//MARK: - Keychain Configuration
public struct KeychainConfiguration {
    static let serviceName = "eu.vwallet.V-Wallet"
    
    /*
     Specifying an access group to use with `KeychainPasswordItem` instances
     will create items shared accross both apps.
     
     For information on App ID prefixes, see:
     https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/AppID.html
     and:
     https://developer.apple.com/library/ios/technotes/tn2311/_index.html
     */
    //    static let accessGroup = "[YOUR APP ID PREFIX].com.example.apple-samplecode.GenericKeychainShared"
    
    /*
     Not specifying an access group to use with `KeychainPasswordItem` instances
     will create items specific to each app.
     */
    static let accessGroup: String? = Bundle.main.bundleIdentifier ?? "eu.vwallet.V-Wallet"
}
