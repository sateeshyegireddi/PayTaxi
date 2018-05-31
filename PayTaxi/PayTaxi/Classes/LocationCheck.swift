//
//  LocationCheck.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 31/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import CoreLocation

class LocationCheck: NSObject {

    func openLocationServicesSettings() {
        
        if !CLLocationManager.locationServicesEnabled() {
            
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                
                if UIApplication.shared.canOpenURL(url) {
                    
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
