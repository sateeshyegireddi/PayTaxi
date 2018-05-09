//
//  Navigation.swift
//  PayTaxiDriver
//
//  Created by Sateesh on 5/9/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class Navigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        OpenScreen().home(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
