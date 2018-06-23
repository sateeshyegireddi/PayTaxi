//
//  Registration.swift
//  PayTaxi
//
//  Created by Sateesh on 5/16/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class Registration: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var userNameTextField: PTTextField!
    @IBOutlet weak var mobileTextField: PTTextField!
    @IBOutlet weak var emailTextField: PTTextField!
    @IBOutlet weak var passwordTextField: PTTextField!
    @IBOutlet var genderButtons: [UIButton]!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet var seperatorSpaces: [NSLayoutConstraint]!
    @IBOutlet weak var elementHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    public enum Gender: String {
        
        case none = ""
        case male = "Male"
        case female = "Female"
        case others = "Others"
    }
    
    public struct UserParameters {
        
        var id: String
        var name: String
        var mobile: String
        var gender: Gender
        var email: String
        var password: String
        var licenseNumber: String
        var vehicleRegistrationNumber: String
        var genderError: String
        
        init() {
            
            id = ""
            name = ""
            mobile = ""
            gender = Gender.none
            email = ""
            password = ""
            licenseNumber = ""
            vehicleRegistrationNumber = ""
            genderError = ""
        }
    }
    
    fileprivate var userParameters: UserParameters!
    fileprivate var userParametersErrors: UserParameters!
    fileprivate var otpId: String!
    fileprivate var otp: String!
    fileprivate var currentTextField: PTTextField?
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init Variables
        userParameters = UserParameters()
        userParametersErrors = UserParameters()
        otpId = ""
        otp = ""
        
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
    private func registerUser() {
        
        let parameters = [GlobalConstants.APIKeys.fullName: userParameters.name,
                          GlobalConstants.APIKeys.mobileNumber: userParameters.mobile,
                          GlobalConstants.APIKeys.email: userParameters.email,
                          GlobalConstants.APIKeys.password: userParameters.password] as [String: Any]
        
        //Request to Driver Registeration API
        APIHandler().registerUser(parameters: parameters) { [weak self] (success, userId, otpId, error) in
            guard let weakSelf = self else { return }
            
            //On success
            if success {
                
                //Make this func async to not getting crash
                DispatchQueue.main.async {
                    
                    //Copy response parameters
                    weakSelf.otpId = otpId ?? ""
                    weakSelf.userParameters.id = userId ?? ""
                    
                    //Show alert with textField to user
                    UtilityFunctions().showAlertWithTextField(OnViewController: weakSelf, message: "Please enter OTP sent to mobile", placeHolder: "OTP", Handler: { (otp) in
                        
                        weakSelf.otp = otp
                        
                        //Request verify OTP API
                        weakSelf.verifyOTP()
                    })
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
        }
        
    }
    
    private func verifyOTP() {
        
        let parameters = [GlobalConstants.APIKeys.userId: userParameters.id,
                          GlobalConstants.APIKeys.otpId: otpId,
                          GlobalConstants.APIKeys.otp: otp] as [String: Any]
        
        //Request to User Registeration API
        APIHandler().verifyOTP(parameters: parameters, completionHandler: { [weak self] (success, error)  in
            guard let weakSelf = self else { return }

            //On success
            if success {
                
                //Move user to Navigation
                DispatchQueue.main.async {
                 
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
    
    private func resendOTP() {
        
        let parameters = [GlobalConstants.APIKeys.userId: userParameters.id,
                          GlobalConstants.APIKeys.otpId: otpId] as [String: Any]
        
        //Request to Driver Registeration API
        APIHandler().resendOTP(parameters: parameters, completionHandler: { [weak self] (success, error) in
            guard let weakSelf = self else { return }
            
            if success {
                
                
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
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        //Hide keyboard
        closeKeyboard()
        
        //Validate fields
        let isFieldsValid = validateInputFields()
        
        //Register user to PayTaxi if all fields are valid
        if isFieldsValid {
            
            //Hide error pop-over message
            UtilityFunctions().hideErrorView(on: self)

            //Call registration API
            registerUser()
        } else {
            
            //Get error message
            let error = getInputFieldError()
            
            //Show error pop-over message to user
            UtilityFunctions().showErrorView(on: self, error: error.message, image: error.image)
        }
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        
        //Reset button highlighting
        for button in genderButtons {
            button.isSelected = false
            button.backgroundColor = UIColor.white
            UtilityFunctions().addRoudedBorder(to: button, borderColor: GlobalConstants.Colors.megnisium, borderWidth: 1)
        }
        
        //Set button as selected
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? GlobalConstants.Colors.aqua : UIColor.clear
        UtilityFunctions().addRoudedBorder(to: sender,
                                           borderColor: sender.isSelected ? UIColor.clear : GlobalConstants.Colors.megnisium,
                                           borderWidth: 1)

        //Get the index of button
        if let index = genderButtons.index(of: sender) {
            
            //Save gender into user parameters
            switch index {
            case 0:
                userParameters.gender = .male
            case 1:
                userParameters.gender = .female
            case 2:
                userParameters.gender = .others
            default:
                userParameters.gender = .none
            }
        }
    }
    
    //MARK: - Keyboard Delegate Method
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        //Move screen little bit up to show fields in 5S
        if UIScreen.main.bounds.width <= 375 {
            
            //Call function to move the view up
            UtilityFunctions().keyboardWillShow(notification, inView: self.view, percent: 0.4)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        //Move screen little bit up to show fields in 5S
        if UIScreen.main.bounds.width <= 375 {
            
            //Call function to move the view back down
            UtilityFunctions().keyboardWillHide(notification, inView: self.view)
        }
    }
    
    func closeKeyboard() {
        
        view.endEditing(true)
    }
    
    //MARK: - Functions
    private func setupUI() {
        
        //Adjust UI for small devices 5S, SE
        for space in seperatorSpaces {
            
            space.constant = UIScreen.main.bounds.width == 320 ? 10 : 20
        }
        elementHeight.constant = UIScreen.main.bounds.width == 320 ? 45 : 50

        //Add topView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self, title: "", enableBack: true)
        view.addSubview(topView)
        
        //Setup imageView
        overlayImageView.image = #imageLiteral(resourceName: "background")
        
        //Setup labels
        UtilityFunctions().setStyleForLabel(welcomeLabel,
                                            text: "welcome_abord".localized,
                                            textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.bigTitleText!)
        UtilityFunctions().setStyleForLabel(registrationLabel,
                                            text: "registration_message".localized,
                                            textColor: GlobalConstants.Colors.iron,
                                            font: GlobalConstants.Fonts.textFieldText!)
        UtilityFunctions().setStyleForLabel(termsAndConditionsLabel,
                                            text: "terms_conditions_message".localized,
                                            textColor: GlobalConstants.Colors.megnisium,
                                            font: GlobalConstants.Fonts.smallMediumText!)

        //Setup textFields
        UtilityFunctions().setTextField(userNameTextField,
                                        text: userParameters.name,
                                        placeHolderText: "user_name".localized,
                                        image:#imageLiteral(resourceName: "icon-user"),
                                        validText: userParameters.name.isEmpty, delegate: self, tag: 100)
        UtilityFunctions().setTextField(mobileTextField,
                                        text: userParameters.mobile,
                                        placeHolderText: "mobile".localized,
                                        image:#imageLiteral(resourceName: "icon-mobile"),
                                        validText: userParameters.mobile.isEmpty, delegate: self, tag: 101)
        UtilityFunctions().setTextField(emailTextField,
                                        text: userParameters.email,
                                        placeHolderText: "email".localized,
                                        image:#imageLiteral(resourceName: "icon-email"),
                                        validText: userParameters.email.isEmpty, delegate: self, tag: 102)
        UtilityFunctions().setTextField(passwordTextField,
                                        text: userParameters.password,
                                        placeHolderText: "password".localized,
                                        image: #imageLiteral(resourceName: "icon-password"),
                                        validText: userParameters.password.isEmpty, delegate: self, tag: 103)
        passwordTextField.isSecureEntry = true
        
        //Setup buttons
        for button in genderButtons {
            UtilityFunctions().addRoudedBorder(to: button, borderColor: GlobalConstants.Colors.megnisium, borderWidth: 1)
        }
        
        registrationButton.setTitle("login".localized, for: .normal)
        registrationButton.backgroundColor = GlobalConstants.Colors.aqua
        registrationButton.titleLabel?.font = GlobalConstants.Fonts.textFieldBoldText!
        UtilityFunctions().addRoudedBorder(to: registrationButton, borderColor: UIColor.clear, borderWidth: 0)
    }

    private func validateInputFields() -> Bool {
        
        //Check field validations
        userParametersErrors.name = Validator().validateUserName(userParameters.name)
        userParametersErrors.mobile = Validator().validateMobile(userParameters.mobile)
        userParametersErrors.email = Validator().validateEmail(userParameters.email)
        userParametersErrors.password = Validator().validatePassword(userParameters.password)
        userParametersErrors.genderError = Validator().validateGender(userParameters.gender.rawValue)

        return userParametersErrors.name.isEmpty && userParametersErrors.mobile.isEmpty && userParametersErrors.email.isEmpty
            && userParametersErrors.password.isEmpty && userParametersErrors.genderError.isEmpty
    }
    
    private func getInputFieldError() -> (message: String, image: UIImage?) {
        
        guard userParametersErrors.name.isEmpty else { return (userParametersErrors.name, #imageLiteral(resourceName: "icon-user-white")) }
        guard userParametersErrors.mobile.isEmpty else { return (userParametersErrors.mobile, #imageLiteral(resourceName: "icon-mobile-white")) }
        guard userParametersErrors.email.isEmpty else { return (userParametersErrors.email, #imageLiteral(resourceName: "icon-email-white")) }
        guard userParametersErrors.password.isEmpty else { return (userParametersErrors.password, #imageLiteral(resourceName: "icon-password-white")) }
        guard userParametersErrors.genderError.isEmpty else { return (userParametersErrors.genderError, #imageLiteral(resourceName: "icon-others-white")) }

        return ("", nil)
    }
}

//MARK: - PTTextField Delegate -

extension Registration: PTTextFieldDelegate {
    
    func PTTextFieldDidBeginEditing(_ textField: UITextField) {
        
        currentTextField = textField.superview as? PTTextField
        textField.inputView = nil
        switch textField.superview!.tag {
        case 100:
            textField.autocorrectionType = .yes
        case 101:
            textField.keyboardType = .numberPad
        case 103:
            textField.autocorrectionType = .yes
            textField.keyboardType = .emailAddress
        default:
            textField.autocorrectionType = .no
            textField.keyboardType = .default
        }
    }
    
    func PTTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        switch textField.superview!.tag {
        case 100, 103:
            return newString.count < 20
        case 101:
            return newString.count < 11
        default:
            return true
        }
    }
    
    func PTTextFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.superview!.tag {
        case 100:
            userParameters.name = textField.text!
        case 101:
            userParameters.mobile = textField.text!
        case 102:
            userParameters.email = textField.text!
        case 103:
            userParameters.password = textField.text!
        default:
            break
        }
    }
}
