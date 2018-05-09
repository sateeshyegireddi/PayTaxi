//
//  Location.swift
//  PayTaxi
//
//  Created by Sateesh on 5/8/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class Location: NSObject {

    var latitude: Double
    var longitude: Double
    var userId: String
    var userName: String

    override init() {
        
        latitude = 0
        longitude = 0
        userId = ""
        userName = ""
    }
}
