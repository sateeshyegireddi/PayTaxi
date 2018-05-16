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
    
    func createMarker(with image: UIImage, at position: CLLocationCoordinate2D, title name: String, placeOn mapView: GMSMapView) -> GMSMarker {
        
        let markerImage = image.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = .red
        
        let marker = GMSMarker(position: position)
//        marker.title = name
        marker.iconView = markerView
        marker.tracksViewChanges = true
        marker.map = mapView
        return marker
    }
}
