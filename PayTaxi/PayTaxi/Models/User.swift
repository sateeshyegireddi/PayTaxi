//
//  User.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {

    //MARK: - Properties
    var id: Int
    var email: String
    var fullName: String
    var mobile: String
    
    //MARK: - Init
    override init() {
        
        id = 0
        email = ""
        fullName = ""
        mobile = ""
    }
    
    init(_ dict: [String: Any]?) {
        
        id = UtilityFunctions().parseInt(in: dict, for: "UserId")
        
        email = dict?["email"] as? String ?? ""
        
        fullName = dict?["fullName"] as? String ?? ""
        
        mobile = dict?["mobileNumber"] as? String ?? ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeInteger(forKey: "id")
        email = aDecoder.decodeObject(forKey: "email") as! String
        fullName = aDecoder.decodeObject(forKey: "fullName") as! String
        mobile = aDecoder.decodeObject(forKey: "mobile") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(mobile, forKey: "mobile")
    }
    
    //MARK: - Print
    func print() {
        
        Swift.print("UserId: \(id) \n email: \(email) \n fullName: \(fullName) \n mobile: \(mobile)")
    }
}

/*
 {
     UserId = 12;
     email = "Ninenine@gmail.com";
     fullName = TestUser;
     mobileNumber = 9999999999;
     sessionId = 9200669466;
 }
 */
