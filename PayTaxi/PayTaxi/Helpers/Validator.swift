//
//  Validator.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 31/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class Validator: NSObject {

    //MARK: - Login -
    func validateMobile(_ text: String) -> String {
        
        let regex = GlobalConstants.Regex.mobile
        let validationMessage = validateText(text, withRegex: regex, errorMessage: "mobile_validation".localized)
        let indianNumber = text.hasPrefix("6") || text.hasPrefix("7") || text.hasPrefix("8") || text.hasPrefix("9")
        if indianNumber {
            return validationMessage
        }
        return "mobile_validation".localized
    }
    
    func validateEmail(_ text: String) -> String {
        
        let regex = GlobalConstants.Regex.email
        let validationMessage = validateText(text, withRegex: regex, errorMessage: "email_validation".localized)
        return validationMessage
    }
    
    func validatePassword(_ text: String) -> String {
        
        let regex = GlobalConstants.Regex.password
        let validationMessage = validateText(text, withRegex: regex, errorMessage: "password_validation".localized)
        return validationMessage
    }
    
    func validateUserName(_ text: String) -> String {
        
        let regex = GlobalConstants.Regex.userName
        let validationMessage = validateText(text, withRegex: regex, errorMessage: "username_validation".localized)
        return validationMessage
    }
    
    func validateGender(_ text: String) -> String {
        
        let regex = GlobalConstants.Regex.gender
        let validationMessage = validateText(text, withRegex: regex, errorMessage: "gender_validation".localized)
        return validationMessage
    }
    
    //MARK: -
    private func validateText(_ text: String, withRegex regex: String, errorMessage error: String) -> String {
        
        //Check if the text is empty
        guard text == "" else {
            
            //Create the predicate with regex-logic
            let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
            
            //Check the conditions specified by the predicate
            let isValid = predicate.evaluate(with: text)
            
            //Return error if it is not valid text
            return isValid ? "" : error
        }
        
        return error
    }
}
