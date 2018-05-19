//
//  Home.swift
//  PayTaxiDriver
//
//  Created by Sateesh on 5/9/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class Home: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var myLocationButton: UIButton!
    
    //MARK: - Variables
    private var longitude = 0.0
    private var latitude = 0.0
    private var mapView: GMSMapView!
    private var cameraZoom: Float = 17.0
    let locationManager = CLLocationManager()
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create and add mapView
        presentMapView()
        
        //Bring all other subViews to front
        view.bringSubview(toFront: myLocationButton)
        
        //Register for location updates
        registerForLocationUpdates()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        
//        return .lightContent
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
        //Get the user's location geo-coordinates
        let myLatitude = mapView.myLocation?.coordinate.latitude
        let myLongiude = mapView.myLocation?.coordinate.longitude
        
        //Animate mapView to new camera position
        let cameraPosition = GMSCameraPosition.camera(withLatitude: myLatitude ?? 0, longitude: myLongiude ?? 0, zoom: cameraZoom)
        mapView.animate(to: cameraPosition)
    }
    
    //MARK: - Functions
    
    private func presentMapView() {
        
        // Create the default camera position with 0, 0 coordinates
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: cameraZoom)
        
        //Create and assign mapView to view
        mapView = GMSMapView.map(withFrame: CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.main.bounds.size), camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        mapView.isTrafficEnabled = true
        view.addSubview(mapView)
        
        //Allow map to show user's location
        mapView.isMyLocationEnabled = true
        
        //Update map GUI
        mapView.mapType = .normal
        //mapView.settings.myLocationButton = true
        //mapView.settings.compassButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 15)
        
        //Set custome style to mapView
        mapView.mapStyle = try? GMSMapStyle.init(jsonString: GlobalConstants.GoogleMapStyle.night)
        
        //Hide mapView initially
        mapView.isHidden = true
        myLocationButton.isHidden = true
    }
    
    private func registerForLocationUpdates() {
        
        //Ask device's permission to use location services
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Start location updates if services are available by user
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
        
        //Move Maps camera position to user location
        let cameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: cameraZoom)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = cameraPosition
            myLocationButton.isHidden = false
        } else {
//            mapView.animate(to: cameraPosition)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Failed to Get User Location. Error Is :: \(error.localizedDescription)")
        locationManager.stopUpdatingLocation()
    }
}
