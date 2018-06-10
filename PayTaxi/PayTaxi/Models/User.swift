//
//  User.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class User: NSObject {

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
