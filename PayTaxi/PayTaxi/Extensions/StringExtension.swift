//
//  StringExtension.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import Foundation

extension String {

    var localized: String {
        
        return NSLocalizedString(self, comment: "")
    }
    
    var trimmedSpace: String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var hashed: String? {
        
        //Create a hash string with capacity of 20
        let hashedString = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        
        //Convert string to data
        if let stringData = self.data(using: String.Encoding.utf8) {
            
            let data = NSData.init(data: stringData)
            
            //Create hash array of type UInt8 with length 32
            var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            
            //Generate hash with given data
            CC_SHA1(data.bytes, CC_LONG(data.length), &hash)
            
            //Looping through hash array
            for byte in hash {
                
                //Append each and every hash byte to hash string
                hashedString.appendFormat("%02x", byte)
            }
            
            //Return hash string
            return hashedString as String
        }
        
        return nil
    }
    
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    func character(at offset: Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: offset)
        return self[index]
    }
    
    func characters(till range: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: range)
        return String(self[..<index])
    }
    
    func charactersfromBack(till range: Int) -> String {
        
        return String(self.suffix(range))
    }
    
    var encryptedString: String {
        
        var encryptedString = ""
        if let data = self.data(using: String.Encoding.utf8) {
            if let encryptedKey = GlobalConstants.Constants.localEncryptionKey.hashed {
                let encryptedData = AESCryptor.encrypt(data: data, withPassword: encryptedKey)
                encryptedString = encryptedData.base64EncodedString()
            }
        }
        return encryptedString
    }
    
    var decryptedString: String {
        
        var decryptedString = ""
        if let data = Data.init(base64Encoded: self) {
            do {
                if let encryptedKey = GlobalConstants.Constants.localEncryptionKey.hashed {
                    let decryptedData = try AESCryptor.decrypt(data: data, withPassword: encryptedKey)
                    decryptedString = String.init(data: decryptedData, encoding: String.Encoding.utf8) ?? ""
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return decryptedString
    }
    
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
