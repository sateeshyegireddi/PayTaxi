//
//  MainMenu.swift
//  PayTaxi
//
//  Created by Sateesh on 5/9/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class MainMenu: UIView {
    
    //MARK: - Outlets
    @IBOutlet var menuTableView: UITableView!
    
    //MARK: - Variables
    weak var vc: UIViewController!
    var titles: [String]!
    var images: [UIImage]!
    var selectedIndex: Int!
    
    //MARK: - View
    override func draw(_ rect: CGRect) {
        
        //Setup View
//        backgroundColor = UIColor.clear
        
        //Setup tableView
        //menuTableView.backgroundColor = UIColor.black
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        //Init Variables
        titles = ["Book a ride", "My rides", "Rate card", "Refer & Earn", "Emergency Contact", "Support"]
        images = [#imageLiteral(resourceName: "icon-marker"), #imageLiteral(resourceName: "icon-marker"), #imageLiteral(resourceName: "icon-marker"), #imageLiteral(resourceName: "icon-marker"), #imageLiteral(resourceName: "icon-marker"), #imageLiteral(resourceName: "icon-marker")]
        selectedIndex = -1
        
        //Register tableView cells
        menuTableView.register(UINib(nibName: "MainMenuCell", bundle: nil), forCellReuseIdentifier: "MainMenuCell")
        
        reloadData()
    }
    
    //MARK: - Actions
    @IBAction func sectionHeaderButtonTapped(_ sender: UIButton) {

    }
    
    @IBAction func menuTopButonTapped(_ sender: UIButton) {
        
        //Close main menu
        switch sender.tag - 100 {
        case 0:
            
            //Move user to home screen
            if let navigation = vc as? Navigation {
                
                navigation.closeMenuView()
                OpenScreen().home(self.vc as! UINavigationController)
            }
        case 6:
            if let navigation = vc as? Navigation {
                
                navigation.closeMenuView()
                //OpenScreen().profile(vc)
            }
            
        case 7:
            if let navigation = vc as? Navigation {
                
                navigation.closeMenuView()
                //OpenScreen().settings(vc)
            }
            
        case 8:
            
            //Call Logout API
            self.logout()
            
        default:
            break
        }
    }
    
    
    //MARK: - Functions
    
    func reloadData() {
        
        menuTableView.reloadData()
    }
    
    func logout() {
        
        /*
        //Create request params
        let params = [GlobalConstants.API_Keys.partyId: UtilityFunctions().getUser()?.id ?? 0]
        
        //Show loader
        vc.showLoader(withText: GlobalConstants.Constants.loading)
        
        //Call logout API
        APIHandler().logout(parameters: params, completionHandler: { [weak self] (success, error) in
            guard let weakSelf = self else { return }
            
            //Remove loader
            weakSelf.vc.hideLoader()
            
            //On success
            if success {
                
                //Make this func async to not have any conflict
                DispatchQueue.main.async {
                    
                    //On success of logout, clear user data, auto login
                    UtilityFunctions().clearKeychainData()
                    UtilityFunctions().setAutoLogin(false)
                    
                    //Close navigation menu and move 'em to login page
                    if let navigation = weakSelf.vc as? Navigation {
                        
                        navigation.closeMenuView()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            
                            OpenScreen().loginFrom(weakSelf.vc)
                        })
                    }
                }
            } else {
                
                //Make this func async to not have any conflict
                DispatchQueue.main.async {
                    
                    UtilityFunctions().showSimpleAlert(OnViewController: weakSelf.vc, Message: error ?? "")
                }
            }
        })
        */
    }
}

//MARK: - UITableView Delegate
extension MainMenu: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainMenuCell", for: indexPath) as! MainMenuCell
        
        //Setup values
        cell.menuTitleLabel.text = titles[indexPath.row]
        cell.menuImageView.image = images[indexPath.row]
        
        //Return cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Create header
        let nibs = Bundle.main.loadNibNamed("MainMenuHeader", owner: self, options: nil)
        let mainMenuHeader = nibs![0] as! MainMenuHeader
        
        //Setup header values
        mainMenuHeader.sectionTitleLabel.text = "User name"
        mainMenuHeader.sectionImageView.image = nil
        mainMenuHeader.sectionImageView.backgroundColor = UIColor.orange
        mainMenuHeader.sectionButton.addTarget(self, action: #selector(MainMenu.sectionHeaderButtonTapped(_:)), for: .touchUpInside)
        
        //Return header view
        return mainMenuHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let navigation = vc as? Navigation {
        
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            default:
                navigation.navigationDelegate?.navigationController(navigation, selectedRow: indexPath.row, at: indexPath.section)
            }
        }
        /*
        if let navigation = vc as? Navigation {
            
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    //OpenScreen().loadWallet(vc, isComingFromDashboard: false)
                case 1:
                    //OpenScreen().subAccounts(vc)
                case 2:
                    OpenScreen().myTransactions(vc, isComingFromDashboard: false)
                default:
                    navigation.navigationDelegate?.navigationController(navigation, selectedRow: indexPath.row, at: indexPath.section)
                    
                }
            case 2:
                switch indexPath.row {
                case 0:
                    OpenScreen().services(vc, screenTitle: "Recharge")
                case 1:
                    OpenScreen().services(vc, screenTitle: "Bill Payments")
                case 2:
                    OpenScreen().services(vc, screenTitle: "Bookings")
                case 3:
                    OpenScreen().manageBenificiaries(vc)
                default:
                    navigation.navigationDelegate?.navigationController(navigation, selectedRow: indexPath.row, at: indexPath.section)
                    
                }
            case 3:
                switch indexPath.row {
                case 0:
                    OpenScreen().services(vc, screenTitle: "Currency Card")
                case 1:
                    OpenScreen().services(vc, screenTitle: "Secondary Card")
                default:
                    navigation.navigationDelegate?.navigationController(navigation, selectedRow: indexPath.row, at: indexPath.section)
                    
                }
            case 4:
                switch indexPath.row {
                case 0:
                    OpenScreen().services(vc, screenTitle: "Payee")
                case 1:
                    OpenScreen().tripleClick(vc)
                case 2:
                    OpenScreen().services(vc, screenTitle: "Cards")
                case 3:
                    OpenScreen().sendMoney(vc, isComingFromDashboard: false, to: nil)//sendMoney(vc, isComingFromDashboard: false, to: nil)
                    
                default:
                    navigation.navigationDelegate?.navigationController(navigation, selectedRow: indexPath.row, at: indexPath.section)
                    
                }
            case 5:
                switch indexPath.row {
                case 0:
                    OpenScreen().services(vc, screenTitle: "Chat")
                    
                case 1:
                    if let phoneCallURL:URL = URL(string: "tel:1234567890") {
                        let application:UIApplication = UIApplication.shared
                        
                        application.open(phoneCallURL, options: [:], completionHandler: { (nil) in
                            
                        })
                    }
                case 2:
                    OpenScreen().services(vc, screenTitle: "Offline")
                default:
                    navigation.navigationDelegate?.navigationController(navigation, selectedRow: indexPath.row, at: indexPath.section)
                    
                }
            default:
                navigation.navigationDelegate?.navigationController(navigation, selectedRow: indexPath.row, at: indexPath.section)
                
            }
            
            navigation.closeMenuView()
        }
        */
    }
}
