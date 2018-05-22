//
//  Place.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 22/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class Place: NSObject {

    var id: String
    var title: String
    var subTitle: String
    
    override init() {
        
        id = ""
        title = ""
        subTitle = ""
    }
    
    init(id: String, title: String, subTitle: String) {
        
        self.id = id
        self.title = title
        self.subTitle = subTitle
    }
}
