//
//  Registration.swift
//  PayTaxiDriver
//
//  Created by Sateesh Yegireddi on 19/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit


class Registration: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var registrationTableView: UITableView!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    //MARK: - Variables
    public enum Gender: String {
        
        case none = ""
        case male = "Male"
        case female = "Female"
    }
    
    public struct UserParameters {
        
        var id: String
        var name: String
        var mobile: String
        var gender: Gender
        var email: String
        var password: String
     
        init() {
            
            id = ""
            name = ""
            mobile = ""
            gender = Gender.none
            email = ""
            password = ""
        }
    }
    
    fileprivate var userParameters: UserParameters!
    fileprivate var otpId: String!
    fileprivate var otp: String!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Init Variables
        userParameters = UserParameters()
        
        //Setup basic UI
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Web Services
    private func registration() {
        
        let parameters = [GlobalConstants.APIKeys.fullName: userParameters.name,
                          GlobalConstants.APIKeys.mobileNumber: userParameters.mobile,
                          GlobalConstants.APIKeys.email: userParameters.email,
                          GlobalConstants.APIKeys.password: userParameters.password] as [String: Any]
        
        //Request to Driver Registeration API
        APIHandler().registrationDriver(parameters: parameters, completionHandler: { (success, error) in
            
            if success {
                
                
            } else {
                
                
            }
        })
        
    }
    
    private func verifyOTP() {
        
        let parameters = [GlobalConstants.APIKeys.userId: userParameters.id,
                          GlobalConstants.APIKeys.otpId: otpId,
                          GlobalConstants.APIKeys.otp: otp] as [String: Any]
        
        //Request to Driver Registeration API
        APIHandler().registrationDriver(parameters: parameters, completionHandler: { (success, error) in
            
            if success {
                
                
            } else {
                
                
            }
        })
    }
    
    private func resendOTP() {
        
        let parameters = [GlobalConstants.APIKeys.userId: userParameters.id,
                          GlobalConstants.APIKeys.otpId: otpId] as [String: Any]
        
        //Request to Driver Registeration API
        APIHandler().resendOTPDriver(parameters: parameters, completionHandler: { (success, error) in
            
            if success {
                
                
            } else {
                
                
            }
        })
    }
    
    //MARK: - Actions
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        
    }
    
    //MARK: - Functions
    private func setupUI() {
        
        //Setup imageView
        overlayImageView.image = #imageLiteral(resourceName: "background")
        logoImageView.image = #imageLiteral(resourceName: "icon-logo")
        
        //Setup View
        UtilityFunctions().addRoudedBorder(to: registrationView, borderColor: UIColor.clear, borderWidth: 0)
        
        //Setup labels
        welcomeLabel.text = "welcome_abord".localized
        welcomeLabel.textColor = GlobalConstants.Colors.blue
        registrationLabel.text = "registration_message".localized
        registrationLabel.textColor = GlobalConstants.Colors.iron
        
        //Setup tableView
        registrationTableView.separatorStyle = .none
        registrationTableView.backgroundColor = UIColor.clear
        registerCells()
        
        //Setup buttons
        registrationButton.setTitle("login".localized, for: .normal)
        registrationButton.backgroundColor = GlobalConstants.Colors.green
        UtilityFunctions().addRoudedBorder(to: registrationButton, borderColor: UIColor.clear, borderWidth: 0)
        loginButton.setTitle("existing_user".localized, for: .normal)
        UtilityFunctions().addAttributedFont(for: loginButton, till: 16)
    }
    
    private func registerCells() {
        
        let nib = UINib(nibName: EditTextFieldCell.identifier, bundle: nil)
        registrationTableView.register(nib, forCellReuseIdentifier: EditTextFieldCell.identifier)
    }
}

//MARK: - UITableView Delegate -

extension Registration: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65 // 12 + 50 + 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: EditTextFieldCell.identifier, for: indexPath) as! EditTextFieldCell
        
        //Setup cell values
        cell.textField.delegate = self
        cell.textField.tag = 100 + indexPath.row
        
        switch indexPath.row {
        case 0:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.name, placeHolderText: "user_name".localized, image: #imageLiteral(resourceName: "icon-user"))
        case 1:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.mobile, placeHolderText: "mobile".localized, image: #imageLiteral(resourceName: "icon-mobile"))
        case 2:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.gender.rawValue, placeHolderText: "gender".localized, image: #imageLiteral(resourceName: "icon-gender"))
        case 3:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.email, placeHolderText: "email".localized, image: #imageLiteral(resourceName: "icon-email"))
        case 4:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.password, placeHolderText: "password".localized, image: #imageLiteral(resourceName: "icon-password"))
        default:
            return UITableViewCell()
        }
        
        //Return cell
        return cell
    }
}

//MARK: - PTTextField Delegate -

extension Registration: PTTextFieldDelegate {
    
    func PTTextFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func PTTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        return true
    }
    
    func PTTextFieldDidEndEditing(_ textField: UITextField) {
    
        
    }
}


