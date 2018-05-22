//
//  MapMarker.swift
//  PayTaxi
//
//  Created by Sateesh on 5/16/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapMarker: NSObject {

    override init() {
        super.init()
    }
    
    func createMarker(with image: UIImage?, at position: CLLocationCoordinate2D, title name: String, placeOn mapView: GMSMapView) -> GMSMarker {
        
        let marker = GMSMarker(position: position)
//        marker.title = name
        marker.icon = image
        marker.tracksViewChanges = true
        marker.map = mapView
        return marker
    }
}
