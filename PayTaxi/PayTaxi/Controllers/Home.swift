//
//  Home.swift
//  PayTaxi
//
//  Created by Sateesh on 5/4/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class Home: UIViewController {

    //MARK: - Outlets
    
    //MARK: - Variables
    var longitude = 0.0
    var latitude = 0.0
    let locationManager = CLLocationManager()

    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let googleMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = googleMapView

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = googleMapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Core Location
    
    func registerForLocationUpdates() {
        
        // Get Device Location -- get let and long of user location
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

//MARK: - CLLocationManager Delegate

extension Home: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Get geographical coordinates from location manager
        let coordinates = manager.location!.coordinate
        print("latitude is:  \(coordinates.latitude) and  longitude is:\(coordinates.longitude)")
        
        //Set the highest possible accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //Save location coorndinates
        latitude = coordinates.latitude
        longitude = coordinates.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Failed to Get User Location. Error Is :: \(error.localizedDescription)")
    }
}

