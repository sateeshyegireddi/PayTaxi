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
import GooglePlaces

class Home: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!
    
    //MARK: - Variables
    let locationManager = CLLocationManager()

    var places: [Place]!
    var fetcher: GMSAutocompleteFetcher?
    private var longitude = 0.0
    private var latitude = 0.0
    private var mapView: GMSMapView!
    private var cameraZoom: Float = 16.5
    private var rootNavigation: Navigation!
    private var markers: [GMSMarker]!
    fileprivate var isFirst: Bool = true
    fileprivate var selectPickDropPointsView: SelectPickDropPointsView!
    fileprivate var searchPlacesView: SearchPlacesView!
    fileprivate var isPickupPointSelection: Bool!
    fileprivate var currentLocationMarker: GMSMarker!
    fileprivate var destinationLocationMarker: GMSMarker!
    fileprivate var cabsView: CabsView!
    fileprivate var polyline: GMSPolyline?
    fileprivate var driverMarker: GMSMarker!

    var trackedUser: [String:AnyObject]!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Init variables
        markers = []
        places = []
        isPickupPointSelection = true
        
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
        
        //Init autoComplete fetcher
        initiateAutoCompleteFetcher()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Web Services
    private func address(for location: CLLocationCoordinate2D) {
        
        //Get address from Google API Services
        APIHandler().address(from: location, completionHandler: { [weak self] (success, address, error) in
            guard let weakSelf = self else { return }
            
            //On sucess
            if success {
                
                //Make this func async not getting crash
                DispatchQueue.main.async {
                    
                    weakSelf.selectPickDropPointsView.pickupPoint.title = address!
                    weakSelf.selectPickDropPointsView.pickPointTextField.text = address
                }
            } else {
                
                //Make this func async not getting crash
                DispatchQueue.main.async {
                    
                    //Show error message to user
                    if error != GlobalConstants.Errors.internetConnection {
                    
                        UtilityFunctions().showSimpleAlert(OnViewController: weakSelf, Message: error!)
                    }
                }
            }
        })
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
        
        //Get address from
        if mapView.myLocation != nil {
        
            //Get the user's location geo-coordinates
            let myLatitude = mapView.myLocation!.coordinate.latitude
            let myLongiude = mapView.myLocation!.coordinate.longitude

            //Update address of the current locaiton
            address(for: mapView.myLocation!.coordinate)
            
            //Animate mapView to new camera position
            let cameraPosition = GMSCameraPosition.camera(withLatitude: myLatitude, longitude: myLongiude, zoom: cameraZoom)
            mapView.animate(to: cameraPosition)
        }
    }
    
    @IBAction func confirmPickupButtonTapped(_ sender: UIButton) {
        
        requestARide(of: .mini)
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
 
    private func addSelectPickAndDropPointsView() {
        
        //Create and add select pickup and drop points view
        selectPickDropPointsView = SelectPickDropPointsView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height == 812 ? 106 : 82, width: view.bounds.width, height: 115), inView: self)
        selectPickDropPointsView.delegate = self
        view.addSubview(selectPickDropPointsView)
        view.bringSubview(toFront: selectPickDropPointsView)
    }
    
    private func addSearchPlacesView() {
        
        //Calculate frame
        let originY: CGFloat = UIScreen.main.bounds.height == 812 ? 106 + 115: 82 + 115
        let frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: view.bounds.height)
        
        //Create and add search places view
        searchPlacesView = SearchPlacesView(frame: frame, inView: self)
        searchPlacesView.delegate = self
        view.addSubview(searchPlacesView)
        view.bringSubview(toFront: searchPlacesView)
    }
    
    private func removeSearchPlacesView() {
        
        searchPlacesView.removeFromSuperview()
    }
    
    private func initiateAutoCompleteFetcher() {
        
        // Set bounds to inner-west Sydney Australia.
//        let neBoundsCorner = CLLocationCoordinate2D(latitude: -33.843366,
//                                                    longitude: 151.134002)
//        let swBoundsCorner = CLLocationCoordinate2D(latitude: -33.875725,
//                                                    longitude: 151.200349)
//        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
//                                         coordinate: swBoundsCorner)
        
        // Set up the autocomplete filter
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "IN"
        
        // Create the fetcher
        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        fetcher?.delegate = self
    }
    
    private func createPolyLinePath(with polyLinePoint: String) {
        
        //Create new path between source and destination
        let routePath = GMSPath(fromEncodedPath: polyLinePoint)
        polyline = GMSPolyline(path: routePath)
        polyline?.strokeColor = GlobalConstants.Colors.orange
        polyline?.strokeWidth = 4.0
        polyline?.map = mapView
        
        //make sure all markers fit in the map
        fitAllMarkers(routePath!)
    }
    
    func showPathBetweenSourceAndDestination() {
        
        let source = selectPickDropPointsView.pickupPoint.title.replacingOccurrences(of: " ", with: "+")
        let destination = selectPickDropPointsView.dropPoint.title.replacingOccurrences(of: " ", with: "+")
        
        //Get routes between source and destination
        APIHandler().getRoutes(from: source, to: destination) { [weak self] (success, distance, duration, polyLinePoint, error) in
            guard let weakSelf = self else { return }
            
            //On success
            if success {
                
                //Make this func async to not getting crash
                DispatchQueue.main.async {
                    
                    weakSelf.createPolyLinePath(with: polyLinePoint!)
                }
                
            } else {
                
                //Make this func async not getting crash
                DispatchQueue.main.async {
                    
                    //Show error message to user
                    if error != GlobalConstants.Errors.internetConnection {
                        
                        UtilityFunctions().showSimpleAlert(OnViewController: weakSelf, Message: error ?? "")
                    }
                }
            }
        }
    }
    
    private func createDestinationMarker(with destination: Place) {
        
        let placeId = destination.id
        GMSPlacesClient().lookUpPlaceID(placeId) { [weak self] (place, error) in
            guard let weakSelf = self else { return }
            
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            guard let place = place else {
                print("No place details for \(placeId)")
                return
            }
            
            //Make this func async to not have getting crash
            DispatchQueue.main.async {
                
                //Remove marker from map before adding
                weakSelf.destinationLocationMarker?.map = nil
                weakSelf.destinationLocationMarker = nil

                //Create destination location marker
                if weakSelf.destinationLocationMarker == nil {
                    
                    weakSelf.destinationLocationMarker = GMSMarker.init(position: place.coordinate)
                    weakSelf.destinationLocationMarker.icon = #imageLiteral(resourceName: "icon-destinaton")
                    weakSelf.destinationLocationMarker.map = weakSelf.mapView
                    weakSelf.destinationLocationMarker.position = place.coordinate
                } else {
                    
                    //Rotate and update current location
                    weakSelf.destinationLocationMarker.position = place.coordinate
                }
                
                weakSelf.showPathBetweenSourceAndDestination()
                weakSelf.addCabsView()
            }
        }
    }
    
    private func fitAllMarkers(_ path: GMSPath) {
        var bounds = GMSCoordinateBounds()
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    private func addCabsView() {
        
        //Calculate frame
        let originY: CGFloat = UIScreen.main.bounds.height == 812 ? view.bounds.height - 260 - 20 : view.bounds.height - 260
        let frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: UIScreen.main.bounds.height == 812 ? 280 : 260)
        
        //Create and add cabs view
        cabsView = CabsView(frame: frame, inView: self)
        cabsView.confirmPickupButton.addTarget(self, action: #selector(confirmPickupButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(cabsView)
        view.bringSubview(toFront: cabsView)
    }
    
    func clearMarkers() {
        
        //Clear all markers, overlays and all..
        for marker in markers {
            marker.map = nil
        }
        markers.removeAll()
        polyline?.map = nil
        currentLocationMarker = nil        
    }
    
    //MARK: - Socket Listening Functions
    
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
        
        //Ride acceptance / decline
        checkRideStatus()
    }
    
    //
    fileprivate func connectUserToSocket() {
        
        //Create request data for socket
        let userId = 17
        let jsonDict = [GlobalConstants.SocketKeys.id: userId,
                        GlobalConstants.SocketKeys.lat: latitude,
                        GlobalConstants.SocketKeys.long: longitude,
                        GlobalConstants.SocketKeys.type: "user"] as [String : Any]
        
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

                    //Clear markers data on map but remember destination marker is also being removed.
                    self.clearMarkers()
                    
                    //Going through each driver's location
                    for driverLocation in driverLocations {
                        
                        //Save latitude and longitude
                        let lat = driverLocation["lat"] as? String ?? ""
                        let long = driverLocation["lng"] as? String ?? ""
                        print("\(lat)----\(long)")
                        
                        //Create geo-coordinate from latitude and longitude
                        let coordinate = CLLocationCoordinate2DMake(Double(lat) ?? 0, Double(long) ?? 0)
                        
                        //Create and add marker with geo-coordinate
                        let marker = MapMarker().createMarker(with: #imageLiteral(resourceName: "icon-taxi"), at: coordinate, title: "", placeOn: self.mapView)
                        marker.map = self.mapView
                        self.markers.append(marker)
                    }
                }
            }
        })
    }
    
    fileprivate func requestARide(of type: GlobalConstants.CabRideType) {
        
        //Create request data for socket
        let userId = 17
        let jsonDict = [GlobalConstants.SocketKeys.id: userId,
                        GlobalConstants.SocketKeys.rideId: arc4random(),
                        GlobalConstants.SocketKeys.cabType: type.rawValue,
                        GlobalConstants.SocketKeys.lat: latitude,
                        GlobalConstants.SocketKeys.long: longitude] as [String : Any]
        
        SocketsManager.sharedInstance.requestARide(with: jsonDict)
    }
    
    fileprivate func checkRideStatus() {
        
        SocketsManager.sharedInstance.rideDidAcceptByDriver(completionHandler: { (data) in
            
            if data.count > 0 {
                
                if let rideDict = data[0] as? [String: Any] {
                    
                    let lat = rideDict["lat"] as? String ?? ""
                    let long = rideDict["lng"] as? String ?? ""
                    let coordinate = CLLocationCoordinate2D(latitude: Double(lat) ?? 0, longitude: Double(long) ?? 0)
                    
                    self.driverMarker?.map = nil
                    self.driverMarker = nil
                    
                    if self.driverMarker == nil {
                        self.driverMarker = GMSMarker(position: coordinate)
                        self.driverMarker.icon = #imageLiteral(resourceName: "icon-taxi")
                        self.driverMarker.map = self.mapView
                        self.driverMarker.position = coordinate
                    }
                    
                    //Create alertController object with specific message
                    let alertController = UIAlertController(title: GlobalConstants.Constants.appName, message: "Driver is arriving", preferredStyle: .alert)
                    
                    //Add OK button to alert and dismiss it on action
                    let alertAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                        
                    }
                    
                    alertController.addAction(alertAction)
                    
                    //Add Cancel button to alert and dismiss it on action
                    let alertAction2 = UIAlertAction(title: "Cancel Ride", style: .default) { (action) in
                        
                        //Call Action handler
                        self.cancelARide()
                    }
                    
                    alertController.addAction(alertAction2)
                    
                    //Show alert to user
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    
    fileprivate func cancelARide() {
        
        //Create request data for socket
        let userId = 17
        let jsonDict = [GlobalConstants.SocketKeys.id: userId,
                        GlobalConstants.SocketKeys.rideId: arc4random() ] as [String : Any]
        
        SocketsManager.sharedInstance.cancelARideFromUser(with: jsonDict)
    }
}

//MARK: - CLLocationManager Delegate -

extension Home: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Get geographical coordinates from location manager
        let coordinate = manager.location!.coordinate
        //print("latitude is:  \(coordinates.latitude) and  longitude is:\(coordinates.longitude)")
        
        //Set the highest possible accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //Save location coorndinates
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        
        //Create current location marker
        if currentLocationMarker == nil {
            
            currentLocationMarker = GMSMarker.init(position: coordinate)
            currentLocationMarker.map = mapView
            currentLocationMarker.icon = #imageLiteral(resourceName: "icon-source")
            currentLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        } else {
            
            //Rotate and update current location
            currentLocationMarker.icon = #imageLiteral(resourceName: "icon-source")
            currentLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            let head = locationManager.location?.course ?? 0
            currentLocationMarker.rotation = head
            currentLocationMarker.position = coordinate
        }
        
        if isFirst {
         
            isFirst = false
            connectUserToSocket()
            address(for: coordinate)
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
            OpenScreen().locationSettings(self)
        case .denied:
            print("User denied access to location.")
            OpenScreen().locationSettings(self)
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
            OpenScreen().locationSettings(self)
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            if let locationSettings = presentedViewController as? LocationSettings {
                locationSettings.dismiss(animated: false, completion: nil)
            }
            print("Location status is OK.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Failed to Get User Location. Error Is :: \(error.localizedDescription)")
        locationManager.stopUpdatingLocation()
    }
}

//MARK: - Navigation Delegate -

extension Home: NavigationDelegate {
    
    func navigationController(_ navigationController: UINavigationController, selectedRow row: Int, at section: Int) {
        
        print("selectedRow: \(row) Section: \(section)")
    }
}

//MARK: - GMSAutocompleteFetcher Delegate -
extension Home: GMSAutocompleteFetcherDelegate {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        //Remove all places first
        places.removeAll()
        
        //Add new place from autoCompletePrediction
        for prediction in predictions {
            let place = Place(id: prediction.placeID ?? "", title: prediction.attributedPrimaryText.string, subTitle: prediction.attributedFullText.string)
            places.append(place)
            print("\n",prediction.attributedFullText.string)
            print("\n",prediction.attributedPrimaryText.string)
            print("\n********")
        }
        
        //Reload data
        searchPlacesView.places = places
        searchPlacesView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
        print(error.localizedDescription)
    }
}

//MARK: - SearchPlacesView Delegate -
extension Home: SearchPlacesViewDelegate {
    
    func placeDidSelect(_ place: Place) {
        
        if isPickupPointSelection {
            selectPickDropPointsView.pickupPoint = place
            selectPickDropPointsView.pickPointTextField.text = place.title
        } else {
            selectPickDropPointsView.dropPoint = place
            selectPickDropPointsView.dropPointTextField.text = place.title
            clearMarkers()
            createDestinationMarker(with: place)
        }
        
        view.endEditing(true)
        
        //Remove search places view after selection of particular place
        removeSearchPlacesView()
    }
}

//MARK: - SelectPickDropPointsView Delegate -
extension Home: SelectPickDropPointsViewDelegate {
    
    func pickPointTextFieldDidChange(_ textField: UITextField) {
        
        isPickupPointSelection = true
        fetcher?.sourceTextHasChanged(textField.text)
    }
    
    func dropPointTextFieldDidChange(_ textField: UITextField) {
        
        isPickupPointSelection = false
        fetcher?.sourceTextHasChanged(textField.text)
    }
    
    func placeTextFieldDidBeginEditing(_ textField: UITextField) {
        
        //Show search places view while searching for places
        addSearchPlacesView()
    }
    
    func placeTextFieldDidEndEditing(_ textField: UITextField) {
        
        //Remove search places view after selection of particular place
        removeSearchPlacesView()
    }
}
