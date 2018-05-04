//
//  GlobalConstants.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

public struct GlobalConstants {

    //MARK: - 
    struct Constants {
        
        static let appName = "PayTaxi"
        static let loading = "Loading"
        static let topViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 95)
        static let localEncryptionKey = "LDUH!Zpq^yFnrhkPMy4Yevybx%WB*3428009wLgERlH"
    }
    
    //MARK: -
    struct API {
        
        static let baseURL = ""

        //Registration, Login, Logout
        static let register = "registration"
    }
    
    //MARK: -
    struct APIHeaderFieldKeys {
        
        static let deviceInfo = "device-info"
        static let deviceUDID = "device-uid"
        static let deviceToken = "device-token"
        static let deviceType = "device-type"
        static let applicationType = "application-type"
        static let ipAddress = "ip-address"
        static let apiToken = "session-token"
        static let contentType = "Content-Type"
        static let language = "language"
        static let authToken = "auth-token"
    }
    
    //MARK: -
    struct APIHeaderFieldValues {
       
        static let applicationJson = "application/json"
        static let deviceType = "I"
        static let applicationType = "1"
    }
    
    //MARK: -
    struct APIKeys {
        
        //Login
        static let email = "email"
    }
    
    //MARK: -
    struct Errors {
        
        static let internetConnectionError = "Internet connection not available"
    }
    
    //MARK: -
    struct UserDefaultsConstants {
        
        static let kLaunchedBefore = "kPayTaxi_have_been_launched_before"
        static let kAutoLogin = "kPayTaxi_auto_login"
        static let kBiometricSettings = "kBiometric_settings"
        static let kNotificationCount = "kNotifications_count"
        static let kDeviceToken = "kDevice_Token"
    }
    
    struct KeyChainConstants {
        
        static let kApiToken = "kVWallet_api_token"
        static let kUser = "kVWallet_current_user"
        static let kAuthToken = "kWallet_auth_token"
    }
    
    //MARK: -
    struct Colors {
     
        static let orange = UIColor(red: 242/255, green: 138/255, blue: 0, alpha: 1)
    }
    
    //MARK: -
    struct Fonts {
        
        static let titleText = UIFont(name: "OpenSans-Regular", size: 13.0)
    }
    
    //MARK: -
    struct GoogleKeys {
        
        static let APIKey = "AIzaSyBUHL8D1R31ARmKvXmig-PyohDSP9FKKSA"
    }
    
    //MARK: -
    struct Localisation {
        
        static let key = "i18n_language"
        static let english = "en"
        static let hindi = "hi"
    }
    
    //MARK: -
    struct Segue {
        
        static let splashToHome = "SplashToHome"
    }
    
    //MARK: -
    struct Notifications {
        
        //Notification
        static let NotificationsDidChangeNotification = "UserNotificationsHasBeenChanged"
    }
}
