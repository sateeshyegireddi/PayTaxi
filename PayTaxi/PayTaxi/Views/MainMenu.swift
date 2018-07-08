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
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var logoutImageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    //MARK: - Variables
    weak var vc: UIViewController!
    var titles: [String]!
    var images: [UIImage]!
    var selectedIndex: Int!
    
    //MARK: - View
    override func draw(_ rect: CGRect) {
        
        
        //Init Variables
        titles = ["home".capitalized.localized, "my_profile".localized, "ride_history".localized, "offers".localized,
                  "notifications".localized, "help_support".localized]
        images = [#imageLiteral(resourceName: "icon-home-gray"), #imageLiteral(resourceName: "icon-user-gray"), #imageLiteral(resourceName: "icon-ride-history"), #imageLiteral(resourceName: "icon-offers"), #imageLiteral(resourceName: "icon-notifications-gray"), #imageLiteral(resourceName: "icon-help"), #imageLiteral(resourceName: "icon-logout")]
        selectedIndex = -1
        
        //Setup View
        overlayView.backgroundColor = UIColor.white
        UtilityFunctions().addRoudedBorder(to: overlayView, showCorners: false, borderColor: GlobalConstants.Colors.iron, borderWidth: 0, showShadow: true)
        
        //Setup ImageView
        overlayImageView.image = #imageLiteral(resourceName: "menu-background")
        logoutImageView.image = #imageLiteral(resourceName: "icon-logout")
        
        //Setup Button
        logoutButton.titleLabel?.font = GlobalConstants.Fonts.textFieldText!
        logoutButton.titleLabel?.textColor = GlobalConstants.Colors.megnisium
        
        //Setup TableView
        menuTableView.backgroundColor = UIColor.clear
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        //Register tableView cells
        menuTableView.register(UINib(nibName: "MainMenuCell", bundle: nil), forCellReuseIdentifier: "MainMenuCell")
        
        reloadData()
    }

    //MARK: - Actions
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        //Logout user from PayTaxi
        logout()
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
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
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
