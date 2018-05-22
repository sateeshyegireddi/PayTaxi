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
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!
    
    //MARK: - Variables
    let locationManager = CLLocationManager()

    private var longitude = 0.0
    private var latitude = 0.0
    private var mapView: GMSMapView!
    private var cameraZoom: Float = 16.5
    private var rootNavigation: Navigation!
    private var markers: [String: GMSMarker]!
    fileprivate var isFirst: Bool = true
    fileprivate var selectPickDropPointsView: SelectPickDropPointsView!
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
        
        //Register for location updates
        registerForLocationUpdates()
        
        //Listen to sever events
        listenToEvents()
        
        //Setup Buttons
        UtilityFunctions().addRoudedBorder(to: myLocationButton, showCorners: false, borderColor: UIColor.clear, borderWidth: 0, showShadow: true)
        view.bringSubview(toFront: menuButton)
        view.bringSubview(toFront: notificationsButton)
        view.bringSubview(toFront: myLocationButton)
        
        //Add Select pickup and drop points view
        addSelectPickAndDropPointsView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    
    @IBAction func notificationsButtonTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        
        if let navigation = navigationController as? Navigation {
            
            navigation.toggleMenu()
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
        //Get the user's location geo-coordinates
        let myLatitude = mapView.myLocation?.coordinate.latitude
        let myLongiude = mapView.myLocation?.coordinate.longitude
        
        /*
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
        */
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
    
    func addSelectPickAndDropPointsView() {
        
        //Create and add select pickup and drop points view
        selectPickDropPointsView = SelectPickDropPointsView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height == 812 ? 106 : 82, width: view.bounds.width, height: 115), inView: self)
        view.addSubview(selectPickDropPointsView)
        view.bringSubview(toFront: selectPickDropPointsView)
    }
    
    //MARK: - Socket Functions
    
    //Listen to all necessary events
    private func listenToEvents() {
        
        listenToConnectionChanges()
        listenToDriverUpdate()
    }
    
    func listenToConnectionChanges() {
        SocketsManager.sharedInstance.listenToConnectionChanges(onConnectHandler: {
            
            //if user was successfully connected to server we ask for a updated drivers list
            self.locationManager.startUpdatingLocation()
            
        }, onDisconnectHandler: {
            
            //if user was disconnected from server we update the app interface
            self.locationManager.stopUpdatingLocation()
            
        })
    }
    
    //Listen to updates in drivers list, whenever it is updated or when we request
    func listenToDriverUpdate() {
        
        //Fetch near by cabs
        fetchNearByCabs()
    }
    
    //
    fileprivate func connectUserToSocket() {
        
        //Create request data for socket
        let userId = 17
        let jsonDict = [GlobalConstants.SocketKeys.id: userId,
                        GlobalConstants.SocketKeys.lat: latitude,
                        GlobalConstants.SocketKeys.long: longitude] as [String : Any]
        
        //Connect user to socket server with specific user data
        SocketsManager.sharedInstance.connectUser(with: jsonDict)
        
        //Request to fetch near by cabs for user
        requestToFetchNearByCabs(ofType: .mini)
    }
    
    fileprivate func requestToFetchNearByCabs(ofType type: GlobalConstants.CabRideType) {
        
        //Create request data for socket
        let userId = 17
        let jsonDict = [GlobalConstants.SocketKeys.id: userId,
                        GlobalConstants.SocketKeys.cabType: type.rawValue,
                        GlobalConstants.SocketKeys.lat: latitude,
                        GlobalConstants.SocketKeys.long: longitude] as [String : Any]
        
        //Request to get near by cabs for user by sending request to socket server
        SocketsManager.sharedInstance.requestToFindNearByCabs(with: jsonDict)
    }
    
    fileprivate func fetchNearByCabs() {
        
        //Get near by cabs for user by sending request to socket server
        SocketsManager.sharedInstance.fetchNearByCabs(completionHandler: { (driverLocationsData) in
            
            //Check if drivers data exists
            if driverLocationsData.count > 0 {
                
                //Copy drivers location object from data object
                if let driverLocations = driverLocationsData[0] as? [[String: Any]] {
                
                    //Going through each driver's location
                    for driverLocation in driverLocations {
                        
                        //Save latitude and longitude
                        let lat = driverLocation["lat"] as? String ?? ""
                        let long = driverLocation["lng"] as? String ?? ""
                        print("\(lat)----\(long)")
                    }
                }
            }
        })
    }
}

//MARK: - CLLocationManager Delegate

extension Home: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Get geographical coordinates from location manager
        let coordinates = manager.location!.coordinate
        //print("latitude is:  \(coordinates.latitude) and  longitude is:\(coordinates.longitude)")
        
        //Set the highest possible accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //Save location coorndinates
        latitude = coordinates.latitude
        longitude = coordinates.longitude
        
        if isFirst {
         
            isFirst = false
            connectUserToSocket()
        }
        
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

/*
class ViewController: UIViewController {
    
    var markers: [GMSMarker]!
    var mapView: GMSMapView!
    var path: GMSPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
         //Check if the location services are enabled
         if !CLLocationManager.locationServicesEnabled() {
         
         // If general location settings are disabled then open general location settings
         if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
         
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
         } else {
         
         // If general location settings are enabled then open location settings for the app
         if let url = URL(string: UIApplicationOpenSettingsURLString) {
         
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
         }
         */
        
        markers = []
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 17.3850, longitude: 78.4867, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 17.3850, longitude: 78.4867)
        marker.title = "Hyderabad"
        marker.map = mapView
        markers.append(marker)
        
        // Creates a marker in the center of the map.
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 17.3840, longitude: 78.4867)
        marker2.title = "Visakhapatnam"
        marker2.map = mapView
        markers.append(marker2)
        
        let points = "onbiB{l`~MCoEFiAR@CjA~AKz@@?~BBrA"
        path = GMSPath(fromEncodedPath: points)
        let distance = GMSGeometryLength(path!)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.black
        polyline.strokeWidth = 4.0
        polyline.map = mapView
        self.view = mapView
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //self.focusMapToShowAllMarkers()
            self.fitAllMarkers(self.path)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func focusMapToShowAllMarkers() {
        let myLocation: CLLocationCoordinate2D = self.markers.first!.position
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
        
        for marker in self.markers {
            bounds = bounds.includingCoordinate(marker.position)
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 150))
            //self.mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: self.polyLineObject.path!), withPadding: 10))
        }
    }
    
    func fitAllMarkers(_ path: GMSPath) {
        var bounds = GMSCoordinateBounds()
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    var i: UInt = 0
    var timer: Timer!
    var animationPath = GMSMutablePath()
    var animationPolyline = GMSPolyline()
    
    @objc func animatePolylinePath() {
        
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.gray
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
}
*/
