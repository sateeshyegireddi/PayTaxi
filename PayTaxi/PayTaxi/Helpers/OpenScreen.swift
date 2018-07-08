//
//  OpenScreen.swift
//  PayTaxi
//
//  Created by Sateesh on 5/4/18.
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
    
    func sendOTP(_ currentViewController: UIViewController) {
        
        let sendOTP = storyboard.instantiateViewController(withIdentifier: "SendOTP") as! SendOTP
        sendOTP.modalTransitionStyle = modalTransitionStyle
        currentViewController.present(sendOTP, animated: false, completion: nil)
    }
    
    func verifyOTP(_ currentViewController: UIViewController, for mobile: String) {
        
        let verifyOTP = storyboard.instantiateViewController(withIdentifier: "VerifyOTP") as! VerifyOTP
        verifyOTP.modalTransitionStyle = modalTransitionStyle
        verifyOTP.mobile = mobile
        currentViewController.present(verifyOTP, animated: false, completion: nil)
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
    
    func selectDropPoint(_ currentViewController: UIViewController, isPickup pickup: Bool) {
        
        let selectDropPoint = storyboard.instantiateViewController(withIdentifier: "SelectLocation") as! SelectLocation
        selectDropPoint.modalTransitionStyle = modalTransitionStyle
        selectDropPoint.isPickup = pickup
        currentViewController.navigationController?.pushViewController(selectDropPoint, animated: false)
    }
    
    func locationSettings(_ currentViewController: UIViewController) {
        
        let locationSettings = storyboard.instantiateViewController(withIdentifier: "LocationSettings") as! LocationSettings
        locationSettings.modalTransitionStyle = modalTransitionStyle
        currentViewController.present(locationSettings, animated: false, completion: nil)
    }
    
    func payment(_ currentViewController: UIViewController) {
        
        let payments = storyboard.instantiateViewController(withIdentifier: "Payments") as! Payments
        payments.modalTransitionStyle = modalTransitionStyle
        currentViewController.navigationController?.pushViewController(payments, animated: false)
    }
    
    func holdToCancelRide(_ currentViewController: UIViewController) {
        
        let cancelRide = storyboard.instantiateViewController(withIdentifier: "HoldToCancelRide") as! HoldToCancelRide
        cancelRide.modalTransitionStyle = modalTransitionStyle
        currentViewController.navigationController?.pushViewController(cancelRide, animated: false)
    }
    
    func rideNow(_ currentViewController: UIViewController) {
        
        let rideNow = storyboard.instantiateViewController(withIdentifier: "RideNow") as! RideNow
        rideNow.modalTransitionStyle = modalTransitionStyle
        currentViewController.navigationController?.pushViewController(rideNow, animated: false)
    }
    
    func rideComplete(_ currentViewController: UIViewController) {
        
        let rideComplete = storyboard.instantiateViewController(withIdentifier: "RideComplete") as! RideComplete
        rideComplete.modalTransitionStyle = modalTransitionStyle
        currentViewController.navigationController?.pushViewController(rideComplete, animated: false)
    }
    
    func rideHistory(_ currentViewController: UINavigationController) {
        
        let rideHistory = storyboard.instantiateViewController(withIdentifier: "RideHistory") as! RideHistory
        rideHistory.modalTransitionStyle = modalTransitionStyle
        currentViewController.setViewControllers([rideHistory], animated: false)
    }
    
    func rideHistoryDetails(_ currentViewController: UIViewController) {
        
        let rideHistoryDetails = storyboard.instantiateViewController(withIdentifier: "RideHistoryDetails") as! RideHistoryDetails
        rideHistoryDetails.modalTransitionStyle = modalTransitionStyle
        currentViewController.navigationController?.pushViewController(rideHistoryDetails, animated: false)
    }
    
    func cancelRide(_ currentViewController: UIViewController) {
        
        let cancelRide = storyboard.instantiateViewController(withIdentifier: "CancelRide") as! CancelRide
        cancelRide.modalTransitionStyle = modalTransitionStyle
        currentViewController.navigationController?.pushViewController(cancelRide, animated: false)
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
