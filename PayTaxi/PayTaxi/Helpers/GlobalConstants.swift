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
    
    //MARK: -
    struct GoogleMapStyle {
        
        static let night = "[ { \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#242f3e\" } ] }, { \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#746855\" } ] }, { \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#242f3e\" } ] }, { \"featureType\": \"administrative.locality\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#d59563\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#d59563\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#263c3f\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#6b9a76\" } ] }, { \"featureType\": \"road\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#38414e\" } ] }, { \"featureType\": \"road\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#212a37\" } ] }, { \"featureType\": \"road\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#9ca5b3\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#746855\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#1f2835\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#f3d19c\" } ] }, { \"featureType\": \"transit\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#2f3948\" } ] }, { \"featureType\": \"transit.station\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#d59563\" } ] }, { \"featureType\": \"water\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#17263c\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#515c6d\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#17263c\" } ] } ]"
        
        static let retro = "[ { \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#ebe3cd\" } ] }, { \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#523735\" } ] }, { \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#f5f1e6\" } ] }, { \"featureType\": \"administrative\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#c9b2a6\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#dcd2be\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#ae9e90\" } ] }, { \"featureType\": \"landscape.natural\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#93817c\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"geometry.fill\", \"stylers\": [ { \"color\": \"#a5b076\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#447530\" } ] }, { \"featureType\": \"road\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#f5f1e6\" } ] }, { \"featureType\": \"road.arterial\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#fdfcf8\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#f8c967\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#e9bc62\" } ] }, { \"featureType\": \"road.highway.controlled_access\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#e98d58\" } ] }, { \"featureType\": \"road.highway.controlled_access\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#db8555\" } ] }, { \"featureType\": \"road.local\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#806b63\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#8f7d77\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#ebe3cd\" } ] }, { \"featureType\": \"transit.station\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"water\", \"elementType\": \"geometry.fill\", \"stylers\": [ { \"color\": \"#b9d3c2\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#92998d\" } ] } ]"
        
        static let dark = "[ { \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#212121\" } ] }, { \"elementType\": \"labels.icon\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#757575\" } ] }, { \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#212121\" } ] }, { \"featureType\": \"administrative\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#757575\" } ] }, { \"featureType\": \"administrative.country\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#9e9e9e\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"administrative.locality\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#bdbdbd\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#757575\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#181818\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#616161\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#1b1b1b\" } ] }, { \"featureType\": \"road\", \"elementType\": \"geometry.fill\", \"stylers\": [ { \"color\": \"#2c2c2c\" } ] }, { \"featureType\": \"road\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#8a8a8a\" } ] }, { \"featureType\": \"road.arterial\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#373737\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#3c3c3c\" } ] }, { \"featureType\": \"road.highway.controlled_access\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#4e4e4e\" } ] }, { \"featureType\": \"road.local\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#616161\" } ] }, { \"featureType\": \"transit\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#757575\" } ] }, { \"featureType\": \"water\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#000000\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#3d3d3d\" } ] } ]"
        
        static let silver = "[ { \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#f5f5f5\" } ] }, { \"elementType\": \"labels.icon\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#616161\" } ] }, { \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#f5f5f5\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#bdbdbd\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#eeeeee\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#757575\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#e5e5e5\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#9e9e9e\" } ] }, { \"featureType\": \"road\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#ffffff\" } ] }, { \"featureType\": \"road.arterial\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#757575\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dadada\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#616161\" } ] }, { \"featureType\": \"road.local\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#9e9e9e\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#e5e5e5\" } ] }, { \"featureType\": \"transit.station\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#eeeeee\" } ] }, { \"featureType\": \"water\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#c9c9c9\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#9e9e9e\" } ] } ]"
        
        static let aubergine = "[ { \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#1d2c4d\" } ] }, { \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#8ec3b9\" } ] }, { \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#1a3646\" } ] }, { \"featureType\": \"administrative.country\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#4b6878\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#64779e\" } ] }, { \"featureType\": \"administrative.province\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#4b6878\" } ] }, { \"featureType\": \"landscape.man_made\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#334e87\" } ] }, { \"featureType\": \"landscape.natural\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#023e58\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#283d6a\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#6f9ba5\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#1d2c4d\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"geometry.fill\", \"stylers\": [ { \"color\": \"#023e58\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#3C7680\" } ] }, { \"featureType\": \"road\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#304a7d\" } ] }, { \"featureType\": \"road\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#98a5be\" } ] }, { \"featureType\": \"road\", \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#1d2c4d\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#2c6675\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#255763\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#b0d5ce\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#023e58\" } ] }, { \"featureType\": \"transit\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#98a5be\" } ] }, { \"featureType\": \"transit\", \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#1d2c4d\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"geometry.fill\", \"stylers\": [ { \"color\": \"#283d6a\" } ] }, { \"featureType\": \"transit.station\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#3a4762\" } ] }, { \"featureType\": \"water\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#0e1626\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#4e6d70\" } ] } ]"
    }
}
