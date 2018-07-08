//
//  HoldToCancelRide.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 08/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import GoogleMaps

class HoldToCancelRide: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var cancelImageView: UIImageView!
    
    //MARK: - Variables
    private let pulsator = Pulsator()
    private var mapView: GMSMapView!
    private var cameraZoom: Float = 16.5

    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init Variables
        
        // Setup View
        setupView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = cancelImageView.layer.position
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        
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
        view.bringSubview(toFront: cancelImageView)
        
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
    
    func setupView() {
        
        //Add TopView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self,
                              title: "ride_now".localized, enableBack: false, showNotifications: true)
        view.addSubview(topView)

        // Setup Pulse Animation View and its Attributes
        cancelImageView.layer.superlayer?.insertSublayer(pulsator, below: cancelImageView.layer)
        pulsator.start()
        pulsator.numPulse = 5
        pulsator.radius = 200
        pulsator.animationDuration = 5
        pulsator.backgroundColor = GlobalConstants.Colors.orange.cgColor
        
        //Add MapView
        presentMapView()
    }
}
