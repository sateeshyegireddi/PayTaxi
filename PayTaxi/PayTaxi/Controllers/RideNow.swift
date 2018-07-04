//
//  RideNow.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 01/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import GoogleMaps

class RideNow: UIViewController {

    //MARK: - Variables
    private var mapView: GMSMapView!
    private var cameraZoom: Float = 16.5
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Init Variables
        
        //Setup View
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions
    private func setupView() {
        
        //Add TopView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self,
                              title: "ride_now".localized, enableBack: false, showNotifications: true)
        view.addSubview(topView)
        
        //Add Driver Info View
        let driverInfoView = DriverInfoView(frame: view.bounds, on: self)
        driverInfoView.showShareStatusButton(false)
        view.addSubview(driverInfoView)
        
        //Add MapView on top
        presentMapView()
    }
    
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
    }
}
