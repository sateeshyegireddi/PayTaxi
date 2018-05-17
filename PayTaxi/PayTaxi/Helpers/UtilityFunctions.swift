//
//  UtilityFunctions.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class UtilityFunctions: NSObject {

    //MARK: - Internet functions
    func connectionToInternetIsAvailable() -> Bool {
        
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
    func getNetworkType() -> String {
        
        let reachability: Reachability = Reachability.forInternetConnection()
        switch reachability.currentReachabilityStatus().rawValue {
        case 1:
            return "Wifi"
        case 2:
            return "Cellular"
        default:
            return "Unknow"
        }
    }
    
    func getNetworkStatus() -> Int {
        
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus
    }
    
    func getIPAddressOfNetworkInterface() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    
    //MARK: - General Functions
    func setAutoLogin(_ bool: Bool) {
        
        if bool {
            UserDefaults.standard.set(true, forKey: GlobalConstants.UserDefaultsConstants.kAutoLogin)
        } else {
            UserDefaults.standard.set(false, forKey: GlobalConstants.UserDefaultsConstants.kAutoLogin)
        }
        UserDefaults.standard.synchronize()
    }
    
    func isAutoLogin() -> Bool {
        
        let isAutoLogin = UserDefaults.standard.bool(forKey: GlobalConstants.UserDefaultsConstants.kAutoLogin)
        return isAutoLogin
    }
    
    func saveLanguage(_ lang: String) {
        
        UserDefaults.standard.set(lang, forKey: GlobalConstants.Localisation.key)
        UserDefaults.standard.synchronize()
    }
    
    func currentLanguage() -> String {
        
        return UserDefaults.standard.string(forKey: GlobalConstants.Localisation.key) ?? GlobalConstants.Localisation.english
    }
    
    func clearKeychainData() {
        
        do {
            try Keychain.standard.clearKeyChain()
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func saveApiToken(_ token: String) {
        
        do {
            try Keychain.standard.saveApiToken(token)
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func getApiToken() -> String {
        
        do {
            return try Keychain.standard.getApiToken()
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        return ""
    }
    
    
    func saveAuthToken(_ token: String) {
        
        do {
            try Keychain.standard.saveAuthToken(token)
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func getAuthToken() -> String {
        
        do {
            return try Keychain.standard.getAuthToken()
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        return ""
    }
    
    func saveUser(_ user: User) {
        
        do {
            try Keychain.standard.saveUser(user)
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func getUser() -> User? {
        
        do {
            return try Keychain.standard.getUser()
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        return nil
    }
    
    func saveDeviceToken(_ token: String) {
        
        UserDefaults.standard.set(token, forKey: GlobalConstants.UserDefaultsConstants.kDeviceToken)
        UserDefaults.standard.synchronize()
    }
    
    func deviceToken() -> String {
        
        return UserDefaults.standard.string(forKey: GlobalConstants.UserDefaultsConstants.kDeviceToken) ?? ""
    }
    
    //MARK: - Model
    func parseDouble(in dict: [String: Any]?, for key: String) -> Double {
        
        var double = 0.00
        
        if let value = dict?[key] as? String {
            double = Double(value) ?? 0
        } else if let value = dict?[key] as? Int {
            double = Double(value)
        } else if let value = dict?[key] as? Double {
            double = value
        }
        
        return double
    }
    
    func parseInt(in dict: [String: Any]?, for key: String) -> Int {
        
        var int = 0
        
        if let value = dict?[key] as? String {
            int = Int(value) ?? 0
        } else if let value = dict?[key] as? Int {
            int = Int(value)
        }
        
        return int
    }
    
    func parseString(in dict: [String: Any]?, for key: String) -> String {
        
        var str = ""
        
        if let value = dict?[key] as? String {
            str = value
        } else if let value = dict?[key] as? Int {
            str = String(value)
        }
        
        return str
    }
    
}
