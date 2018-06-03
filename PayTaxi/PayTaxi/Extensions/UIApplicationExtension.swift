//
//  UIApplicationExtension.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 03/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

extension UIApplication {

    class func topViewController(_ vc: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        //Return visible viewController if current one is in navigation stack
        if let navigationController = vc as? UINavigationController {
            
            return topViewController(navigationController.visibleViewController)
        }
        
        //Return presented viewController if current one is on window
        if let presented = vc?.presentedViewController {
            
            return topViewController(presented)
        }
        
        return vc
    }
}
