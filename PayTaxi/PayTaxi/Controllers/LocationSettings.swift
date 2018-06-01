//
//  LocationSettings.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 31/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import  CoreLocation

class LocationSettings: UIViewController {

    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func locationServicesButtonTapped(_ sender: UIButton) {
        
        openLocationServicesSettings()
    }
   
    //MARK: - Functions
    private func openLocationServicesSettings() {
        
        if !CLLocationManager.locationServicesEnabled() {
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION_SERVICES") {
                // If general location settings are disabled then open general location settings
                UIApplication.shared.openURL(url)
            }
        } else {
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                // If general location settings are enabled then open location settings for the app
                UIApplication.shared.openURL(url)
            }
        }
    }

}
