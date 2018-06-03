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
    func registration(_ currentViewController: UIViewController) {
        
        let registration = storyboard.instantiateViewController(withIdentifier: "Registration") as! Registration
        registration.modalTransitionStyle = modalTransitionStyle
        currentViewController.present(registration, animated: false, completion: nil)
    }
    
    func login(_ currentViewController: UIViewController) {
        
        let login = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
        login.modalTransitionStyle = modalTransitionStyle
        currentViewController.present(login, animated: false, completion: nil)
    }
    
    func navigation(_ currentViewController: UIViewController) {
        
        let navigation = storyboard.instantiateViewController(withIdentifier: "Navigation") as! Navigation
        navigation.modalTransitionStyle = modalTransitionStyle
        currentViewController.present(navigation, animated: false, completion: nil)
    }
    
    func home(_ currentViewController: UINavigationController) {
        
        let home = storyboard.instantiateViewController(withIdentifier: "Home") as! Home
        home.modalTransitionStyle = modalTransitionStyle
        currentViewController.setViewControllers([home], animated: false)
    }
    
    func locationSettings(_ currentViewController: UIViewController) {
        
        let locationSettings = storyboard.instantiateViewController(withIdentifier: "LocationSettings") as! LocationSettings
        locationSettings.modalTransitionStyle = modalTransitionStyle
        currentViewController.present(locationSettings, animated: false, completion: nil)
    }
    /*
     func registration(_ currentViewController: UIViewController) {
     
     let registration = storyboard.instantiateViewController(withIdentifier: "VWRegistration") as! VWRegistration
     registration.modalTransitionStyle = modalTransitionStyle
     
     if let navigation = currentViewController as? Navigation {
     navigation.setViewControllers([registration], animated: false)
     } else {
     currentViewController.navigationController?.setViewControllers([registration], animated: false)
     }
     }
     
     func navigateToVWLogin(_ currentViewController: UIViewController,isLogin:Bool) {
     let login = storyboard.instantiateViewController(withIdentifier: "VWLogin") as! VWLogin
     login.isLogin = isLogin
     login.modalTransitionStyle = modalTransitionStyle
     currentViewController.navigationController?.pushViewController(login, animated: false)
     }
     */
}
