//
//  Splash.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class Splash: UIViewController {

    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!

    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup UI
        overlayImageView.image = #imageLiteral(resourceName: "splashBackground")
        iconImageView.image = #imageLiteral(resourceName: "icon-logo")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check if the user has logged into app already
        let isAutoLogin = false//UtilityFunctions().isAutoLogin()

        if isAutoLogin {
            
            OpenScreen().navigation(self)
        } else {
            
            OpenScreen().login(self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
