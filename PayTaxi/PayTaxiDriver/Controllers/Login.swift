//
//  Login.swift
//  PayTaxiDriver
//
//  Created by Sateesh Yegireddi on 19/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class Login: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var mobileTextField: PTTextField!
    @IBOutlet weak var passwordTextField: PTTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    //MARK: - Variables
    var mobileNumber: String!
    var password: String!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Init variables
        mobileNumber = ""
        password = ""
        
        //Setup basic UI
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        //Call API Service
    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        
        OpenScreen().registration(self)
    }
    
    //MARK: - Functions
    private func setupUI() {
        
        //Setup imageView
        overlayImageView.image = #imageLiteral(resourceName: "background")
        logoImageView.image = #imageLiteral(resourceName: "icon-logo")
        
        //Setup View
        UtilityFunctions().addRoudedBorder(to: loginView, borderColor: UIColor.clear, borderWidth: 0)
        
        //Setup label
        welcomeLabel.text = "welcome_back".localized
        welcomeLabel.textColor = GlobalConstants.Colors.blue
        loginLabel.text = "login_message".localized
        loginLabel.textColor = GlobalConstants.Colors.iron
        
        //Setup textFields
        mobileTextField.delegate = self
        mobileTextField.tag = 100
        UtilityFunctions().setTextField(mobileTextField, text: "", placeHolderText: "mobile".localized, image: #imageLiteral(resourceName: "icon-mobile"))
        passwordTextField.delegate = self
        passwordTextField.tag = 101
        UtilityFunctions().setTextField(passwordTextField, text: "", placeHolderText: "password".localized, image: #imageLiteral(resourceName: "icon-password"))
        passwordTextField.isSecureEntry = true
        
        //Setup button
        forgotPasswordButton.setTitleColor(GlobalConstants.Colors.megnisium, for: .normal)
        forgotPasswordButton.setTitle("forgot_password".localized, for: .normal)
        loginButton.setTitle("login".localized, for: .normal)
        loginButton.backgroundColor = GlobalConstants.Colors.green
        UtilityFunctions().addRoudedBorder(to: loginButton, borderColor: UIColor.clear, borderWidth: 0)
        registrationButton.setTitle("new_user".localized, for: .normal)
        UtilityFunctions().addAttributedFont(for: registrationButton)
    }
}

//MARK: - PTTextField Delegate -
extension Login: PTTextFieldDelegate {
    
    func PTTextFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField.superview!.tag {
        case 100:
            textField.keyboardType = .numberPad
        case 101:
            textField.keyboardType = .default
        default:
            break
        }
    }
    
    func PTTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)

        switch textField.superview!.tag {
        case 100:
            return newString.count < 11
        case 101:
            return newString.count < 20
        default:
            return true
        }
    }
    
    func PTTextFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.superview!.tag {
        case 100:
            mobileNumber = textField.text!
        case 101:
            password = textField.text!
        default:
            break
        }
    }
}




