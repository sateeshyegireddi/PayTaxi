//
//  Login.swift
//  PayTaxi
//
//  Created by Sateesh on 5/16/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class Login: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var mobileTextField: PTTextField!
    @IBOutlet weak var passwordTextField: PTTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    //MARK: - Variables
    fileprivate var mobileNumber: String!
    fileprivate var password: String!
    fileprivate var mobileNumberError: String!
    fileprivate var passwordError: String!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init variables
        mobileNumber = ""
        password = ""
        mobileNumberError = ""
        passwordError = ""
        
        //Add notification listener for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Setup basic UI
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        closeKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove notification listener for the keyboard
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Web Services
    private func login() {
        
        //Create request parameters
        let parameters = [GlobalConstants.APIKeys.mobileNumber: mobileNumber,
                          GlobalConstants.APIKeys.password: password] as [String: Any]
        
        //Request to Login API
        APIHandler().loginUser(with: parameters, completionHandler: { [weak self] (success, error) in
            guard let weakSelf = self else { return }
            
            //On success
            if success {
                
                //Make this func async to not have being crashed
                DispatchQueue.main.async {
                    
                    //Move user to home screen
                    OpenScreen().navigation(weakSelf)
                }
            } else {
                
                //Make this func async not getting crash
                DispatchQueue.main.async {
                    
                    //Show error message to user
                    if error != GlobalConstants.Errors.internetConnection {
                        
                        UtilityFunctions().showSimpleAlert(OnViewController: weakSelf, Message: error ?? "")
                    }
                }
            }
        })
    }
    
    //MARK: - Actions
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        //Hide keyboard
        closeKeyboard()
        
        //Validate fields
        let isFieldsValid = validateInputFields()
        
        //Call login API service if all fields are valid
        if isFieldsValid {
            
            login()
        } else {
            
            //Get error message
            let error = getInputFieldError()
            
            //Show error pop-over message to user
            UtilityFunctions().showSimpleAlert(OnViewController: self, Message: error)
        }
    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        
        OpenScreen().registration(self)
    }
    
    //MARK: - Keyboard Delegate Method
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        //Move screen little bit up to show fields in 5S
        if UIScreen.main.bounds.width == 320 {
            
            //Call function to move the view up
            UtilityFunctions().keyboardWillShow(notification, inView: self.view, percent: 0.3)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        //Move screen little bit up to show fields in 5S
        if UIScreen.main.bounds.width == 320 {
            
            //Call function to move the view back down
            UtilityFunctions().keyboardWillHide(notification, inView: self.view)
        }
    }
    
    func closeKeyboard() {
        
        view.endEditing(true)
    }
    
    //MARK: - Functions
    private func validateInputFields() -> Bool {
        
        //Check field validations
        mobileNumberError = Validator().validateMobile(mobileNumber)
        passwordError = Validator().validatePassword(password)
        
        return mobileNumberError.isEmpty && passwordError.isEmpty
    }
    
    private func setupUI() {
        
        //Setup imageView
        overlayImageView.image = #imageLiteral(resourceName: "background")
        
        //Setup labels
        UtilityFunctions().setStyleForLabel(welcomeLabel,
                                            text: "welcome_back".localized,
                                            textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.bigTitleText!)
        UtilityFunctions().setStyleForLabel(loginLabel,
                                            text: "login_message".localized,
                                            textColor: GlobalConstants.Colors.iron,
                                            font: GlobalConstants.Fonts.textFieldText!)

        //Setup textFields
        UtilityFunctions().setTextField(mobileTextField,
                                        text: mobileNumber,
                                        placeHolderText: "mobile".localized,
                                        image:#imageLiteral(resourceName: "icon-mobile"),
                                        validText: mobileNumberError.isEmpty, delegate: self, tag: 100)
        UtilityFunctions().setTextField(passwordTextField,
                                        text: password,
                                        placeHolderText: "password".localized,
                                        image: #imageLiteral(resourceName: "icon-password"),
                                        validText: mobileNumberError.isEmpty, delegate: self, tag: 101)
        passwordTextField.isSecureEntry = true
        
        //Setup buttons
        loginButton.setTitle("login".localized, for: .normal)
        loginButton.backgroundColor = GlobalConstants.Colors.aqua
        loginButton.titleLabel?.font = GlobalConstants.Fonts.textFieldBoldText!
        UtilityFunctions().addRoudedBorder(to: loginButton, borderColor: UIColor.clear, borderWidth: 0)
        
        registrationButton.setTitle("new_user".localized, for: .normal)
        UtilityFunctions().addAttributedFont(for: registrationButton, till: 22)
        
        forgotPasswordButton.setTitleColor(GlobalConstants.Colors.iron, for: .normal)
        forgotPasswordButton.titleLabel?.font = GlobalConstants.Fonts.smallText!
        forgotPasswordButton.setTitle("forgot_password".localized, for: .normal)
    }
    
    private func getInputFieldError() -> String {
        
        guard mobileNumberError.isEmpty else { return mobileNumberError }
        guard passwordError.isEmpty else { return passwordError }
        
        return ""
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
