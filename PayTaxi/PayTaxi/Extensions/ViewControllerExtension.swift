//
//  ViewControllerExtension.swift
//  PayTaxi
//
//  Created by Sateesh on 5/7/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showLoader(withText text: String) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loader = storyboard.instantiateViewController(withIdentifier: "PTLoading") as! PTLoading
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(loader.view)
        }
        loader.view.accessibilityIdentifier = "PTLoading"
        loader.view.frame = self.view.bounds
    }
    
    func hideLoader() {
        
        //Make this func async to not have conflict
        DispatchQueue.main.async {
            
            //Remove, if there is Activity Indicator added
            if let window = UIApplication.shared.keyWindow {
                
                for subView in window.subviews {
                    if subView.accessibilityIdentifier == "PTLoading" {
                        subView.removeFromSuperview()
                    }
                }
            }
        }
    }
}
