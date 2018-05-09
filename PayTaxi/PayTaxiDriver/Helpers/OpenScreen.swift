//
//  OpenScreen.swift
//  PayTaxiDriver
//
//  Created by Sateesh on 5/9/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class OpenScreen: NSObject {

    //MARK: - Variables
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
    //MARK: - Functions
    func navigation(_ currentViewController: UIViewController) {
        
        let navigation = storyboard.instantiateViewController(withIdentifier: "Navigation") as! Navigation
        navigation.modalTransitionStyle = modalTransitionStyle
        currentViewController.present(navigation, animated: true, completion: nil)
    }
    
    func home(_ currentViewController: UINavigationController) {
        
        let home = storyboard.instantiateViewController(withIdentifier: "Home") as! Home
        home.modalTransitionStyle = modalTransitionStyle
        currentViewController.setViewControllers([home], animated: false)
    }
}
