//
//  Navigation.swift
//  PayTaxi
//
//  Created by Sateesh on 5/4/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

protocol NavigationDelegate {
    
    func navigationController(_ navigationController: UINavigationController, selectedRow row: Int, at section: Int)
}

class Navigation: UINavigationController {

    //MARK: - Variables
    var isUserExists: Bool!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var navigationDelegate: NavigationDelegate?
    let shadowAlpha: CGFloat! = 0.5
    let menuDuration: CGFloat! = 0.3
    let menuTriggerVelocity: CGFloat! = 350
    var isOpen: Bool!
    var menuHeight: CGFloat!
    var menuWidth: CGFloat!
    var outFrame: CGRect!
    var inFrame: CGRect!
    var shadowView: UIView!
    var menuView: MainMenu!
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup Menu
        setupMenu()
        
        //Move the user home screen
        OpenScreen().home(self)
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//
//        return .lightContent
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    
    @IBAction func tappedOnShadow(_ sender: UITapGestureRecognizer) {
        
        closeMenuView()
    }
    
    @IBAction func menuMoved(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        //On view is began to move
        if sender.state == .began {
            
            //Open menu if gesture velocity is more than trigger velocity
            if velocity.x > menuTriggerVelocity && !isOpen! {
                
                openMenuView()
            } else if velocity.x < -menuTriggerVelocity && isOpen! {
                
                closeMenuView()
            }
        }
        
        //On view is being moved
        if sender.state == .changed {
            
            //Calculate resultant center of menu with gesture translation over time
            let movingX = menuView.center.x + translation.x
            
            //Move the menu view to resultant center
            if movingX > -menuWidth/2 && movingX < menuWidth/2 {
                
                menuView.center = CGPoint(x: movingX, y: menuView.center.y)
                sender.setTranslation(CGPoint.zero, in: view)
                
                //Calculate resultant shadow alpha with gesture translation over time
                let changingAlpha = shadowAlpha / menuWidth * movingX + shadowAlpha / 2 //y = mx + c
                shadowView.isHidden = false
                shadowView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: changingAlpha)
            }
        }
        
        //On view is moved
        if sender.state == .ended {
            
            //Open the menu view if its center > 0
            if menuView.center.x > 0 {
                
                openMenuView()
            } else if menuView.center.x < 0 {
                
                closeMenuView()
            }
        }
    }
    
    //MARK: - Functions
    func toggleMenu() {
        
        //Open/close menu view
        if !isOpen! {
            
            openMenuView()
        } else {
            
            closeMenuView()
        }
    }
    
    private func setupMenu() {
        
        isOpen = false
        
        //Load menu view
        let nibs = Bundle.main.loadNibNamed("MainMenu", owner: self, options: nil)
        menuView = nibs![0] as! MainMenu
        
        //Setup menu variables
        menuWidth = menuView.frame.width
        menuHeight = UIScreen.main.bounds.height
        outFrame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: menuHeight)
        inFrame = CGRect(x: 0, y: 0, width: menuWidth, height: menuHeight)
        
        //Create a shadow for menu view and and a tap gesture recognizer to hide it on tap
        shadowView = UIView(frame: view.frame)
        shadowView.backgroundColor = UIColor.clear
        shadowView.isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Navigation.tappedOnShadow(_:)))
        shadowView.addGestureRecognizer(tapGestureRecognizer)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shadowView)
        
        //Add Menu view
        menuView.frame = outFrame
        menuView.vc = self
        
        view.addSubview(menuView)
        
        //Add pan gesture recoginzer to hide menu
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(Navigation.menuMoved(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func openMenuView() {
        
        let duration = menuDuration / menuWidth * abs(menuView.center.x) + menuDuration / 2 //y = mx + c
        
        //Show shadow and menu animations while opening the menu
        shadowView.isHidden = false
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .curveEaseInOut, animations: {
            self.shadowView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: self.shadowAlpha)
        }, completion: nil)
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .beginFromCurrentState, animations: {
            self.menuView.frame = self.inFrame
        }, completion: nil)
        
        isOpen = true
    }
    
    func closeMenuView() {
        
        let duration = menuDuration / menuWidth * abs(menuView.center.x) + menuDuration / 2
        
        //Show shadow and menu animations while closing the menu
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .curveEaseInOut, animations: {
            self.shadowView.backgroundColor = UIColor.clear
        }, completion: { (finished) in
            self.shadowView.isHidden = true
        })
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .beginFromCurrentState, animations: {
            self.menuView.frame = self.outFrame
        }, completion: nil)
        
        isOpen = false
    }

}
