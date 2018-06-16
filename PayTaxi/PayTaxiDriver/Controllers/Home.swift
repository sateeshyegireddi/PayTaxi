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
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!
    
    //MARK: - Variables
    let locationManager = CLLocationManager()
    
    private var longitude = 0.0
    private var latitude = 0.0
    private var mapView: GMSMapView!
    private var cameraZoom: Float = 17.0
    private var rootNavigation: Navigation!
    private var markers: [String: GMSMarker]!
    
    var trackedUser: [String:AnyObject]!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init variables
        markers = [:]
        
        rootNavigation = navigationController as! Navigation
        rootNavigation.navigationDelegate = self
        
        //Create and add mapView
        presentMapView()
        
        //Bring all other subViews to front
        view.bringSubview(toFront: myLocationButton)
        view.bringSubview(toFront: menuButton)
        
        //Register for location updates
        registerForLocationUpdates()
        
        //Listen to sever events
        listenToEvents()
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
        
        let source = "\(myLatitude!),\(myLongiude!)"
        let destination = "17.6868,83.2185"
        
        //Get routes between source and destination
        APIHandler().getRoutes(from: source, to: destination, completionHandler: { (success, distance, duration, polylinePointsString, error) in
            
            //On success
            if success {
                
                //Make this func async to not have any conflict
                DispatchQueue.main.async {
                    
                    //Draw a physical line path between source and destination
                    let path = GMSPath(fromEncodedPath: polylinePointsString ?? "")
                    let polyline = GMSPolyline(path: path)
                    polyline.map = self.mapView
                    
                    
                }
            } else {
                
            }
        })
        /*
         //Animate mapView to new camera position
         let cameraPosition = GMSCameraPosition.camera(withLatitude: myLatitude ?? 0, longitude: myLongiude ?? 0, zoom: cameraZoom)
         mapView.animate(to: cameraPosition)
         */
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        
        if let navigation = navigationController as? Navigation {
            
            navigation.toggleMenu()
        }
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
        mapView.mapStyle = try? GMSMapStyle.init(jsonString: GlobalConstants.GoogleMapStyle.silver)
        
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
    
    private func addMarkers() {
        
        DispatchQueue.main.async {
            
            //Create marker
            let marker = MapMarker().createMarker(with: #imageLiteral(resourceName: "icon-marker"), at: CLLocationCoordinate2D(latitude: 17.6868, longitude: 83.2185), title: "Vizag", placeOn: self.mapView)
            let currentLocationMarker = MapMarker().createMarker(with: nil, at: self.mapView.myLocation!.coordinate, title: "Hyderabad", placeOn: self.mapView)
            self.markers.updateValue(marker, forKey: "Vizag")
            self.markers.updateValue(currentLocationMarker, forKey: "Hyderabad")
            
            //TODO: Add Fit to bounds only show the placed markers on the map
        }
    }
    
    //Listen to all necessary events
    private func listenToEvents() {
        
        addHandlers()
        
        //        listenToConnectionChanges()
        //        listenToDriversListUpdate()
    }
    
    private func addHandlers() {
        SocketsManager.sharedInstance.socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        SocketsManager.sharedInstance.socket.on("chat message") {[weak self] data, ack in
            if let value = data.first as? String {
                print(value)
            }
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


//MARK: - Navigation Delegate

extension Home: NavigationDelegate {
    
    func navigationController(_ navigationController: UINavigationController, selectedRow row: Int, at section: Int) {
        
        print("selectedRow: \(row) Section: \(section)")
    }
}
