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
//    var images: [UIImage]!
    var selectedIndex: Int!
    
    //MARK: - View
    override func draw(_ rect: CGRect) {
        
        //Setup View
        backgroundColor = UIColor.clear
        
        //Setup tableView
        menuTableView.backgroundColor = UIColor.black
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        //Init Variables
        titles = ["Home", "My Wallet", "Services", "Cards", "Payments", "Support", "My Profile", "Settings", "Logout"]
//        images = [#imageLiteral(resourceName: "icon-home-border"),#imageLiteral(resourceName: "icon-my-wallet"), #imageLiteral(resourceName: "icon-service"), #imageLiteral(resourceName: "icon-card"), #imageLiteral(resourceName: "icon-payment"), #imageLiteral(resourceName: "icon-support"), #imageLiteral(resourceName: "icon-myProfile"),#imageLiteral(resourceName: "icon-settings"), #imageLiteral(resourceName: "icon-logout")]
        selectedIndex = -1
        
        //Register tableView cells
        menuTableView.separatorStyle = .none
        menuTableView.register(UINib(nibName: "MainMenuCell", bundle: nil), forCellReuseIdentifier: "MainMenuCell")
        reloadData()
    }
    
    //MARK: - Actions
    @IBAction func sectionHeaderButtonTapped(_ sender: UIButton) {
        
        //Close the menu, if user tap the same section, again
        if selectedIndex == sender.tag - 100 {
            
            selectedIndex = -1
        } else {
            
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
                logoutFromVWallet()
                
            default:
                break
            }
            
            selectedIndex = sender.tag - 100
        }
        
        reloadData()
    }
    
    @IBAction func menuTopButonTapped(_ sender: UIButton) {
        
        //Close main menu
        if let navigation = vc as? Navigation {
            
            navigation.closeMenuView()
        }
    }
    
    
    //MARK: - Functions
    
    func reloadData() {
        
        menuTableView.reloadData()
    }
    
    func logoutFromVWallet() {
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Create header
        let nibs = Bundle.main.loadNibNamed("MainMenuHeader", owner: self, options: nil)
        let mainMenuHeader = nibs![0] as! MainMenuHeader
        
        //Setup header values
//        mainMenuHeader.setupValuesInHeader(WithTitle: titles[section], Image: images[section])
        mainMenuHeader.sectionButton.tag = section + 100
        mainMenuHeader.sectionButton.addTarget(self, action: #selector(MainMenu.sectionHeaderButtonTapped(_:)), for: .touchUpInside)
        
        //Don't need add >/v icon if it is logout
        if (section != titles.count - 1) && (section != 0) && (section != titles.count - 2) && (section != titles.count - 3) {
            
            mainMenuHeader.highlightHeaderSection(section == selectedIndex)
        }
        
        //Return header view
        return mainMenuHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainMenuCell", for: indexPath) as! MainMenuCell
        
        //Setup values
//        cell.setTitle(menuTitles[indexPath.section][indexPath.row])
        
        //Return cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
