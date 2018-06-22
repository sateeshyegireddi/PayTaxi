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
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var registrationTableView: UITableView!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    
    @IBOutlet weak var registrationButton: UIButton!

    //MARK: - Variables
    public struct UserParameters {
        
        var id: String
        var name: String
        var mobile: String
        var email: String
        var password: String
        var licenseNumber: String
        var vehicleRegistrationNumber: String

        init() {
            
            id = ""
            name = ""
            mobile = ""
            email = ""
            password = ""
            licenseNumber = ""
            vehicleRegistrationNumber = ""
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
    private func registerDriver() {
        
        let parameters = [GlobalConstants.APIKeys.fullName: userParameters.name,
                          GlobalConstants.APIKeys.mobileNumber: userParameters.mobile,
                          GlobalConstants.APIKeys.email: userParameters.email,
                          GlobalConstants.APIKeys.password: userParameters.password] as [String: Any]
        
        //Request to Driver Registeration API
        APIHandler().registrationDriver(parameters: parameters, completionHandler: { [weak self] (success, userId, otpId, error) in
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
                
                //Make this func async to not getting crash
                DispatchQueue.main.async {
                    
                    //Show error message to user
                    UtilityFunctions().showSimpleAlert(OnViewController: weakSelf, Message: error ?? "")
                }
            }
        })
        
    }
    
    private func verifyOTP() {
        
        let parameters = [GlobalConstants.APIKeys.userId: userParameters.id,
                          GlobalConstants.APIKeys.otpId: otpId,
                          GlobalConstants.APIKeys.otp: otp] as [String: Any]
        
        //Request to User Registeration API
        APIHandler().verifyOTP(parameters: parameters, completionHandler: { [weak self] (success, error) in
            guard let weakSelf = self else { return }
            
            //On success
            if success {
                
                //Move user to Navigation
                DispatchQueue.main.async {
                    
                    OpenScreen().navigation(weakSelf)
                }
                
            } else {
                
                //Make this func async to not getting crash
                DispatchQueue.main.async {
                    
                    //Show error message to user
                    UtilityFunctions().showSimpleAlert(OnViewController: weakSelf, Message: error ?? "")
                }
            }
        })
    }
    
    private func resendOTP() {
        
        let parameters = [GlobalConstants.APIKeys.userId: userParameters.id,
                          GlobalConstants.APIKeys.otpId: otpId] as [String: Any]
        
        //Request to Driver Registeration API
        APIHandler().resendOTP(parameters: parameters, completionHandler: { (success, error) in
            
            if success {
                
                
            } else {
                
                
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
            
            registerDriver()
        } else {
            
            //Get error message
            let error = getInputFieldError()
            
            //Show error pop-over message to user
            UtilityFunctions().showSimpleAlert(OnViewController: self, Message: error)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Keyboard Delegate Method
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        //Move screen little bit up to show fields in 5S
        if UIScreen.main.bounds.width <= 375 {
            
            //Call function to move the view up
            UtilityFunctions().keyboardWillShow(notification, inView: self.view, percent: 0.35)
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
        registrationButton.setTitle("signup".localized, for: .normal)
        registrationButton.backgroundColor = GlobalConstants.Colors.green
        UtilityFunctions().addRoudedBorder(to: registrationButton, borderColor: UIColor.clear, borderWidth: 0)
        loginButton.setTitle("existing_user".localized, for: .normal)
        UtilityFunctions().addAttributedFont(for: loginButton, till: 16)
    }
    
    private func registerCells() {
        
        let nib = UINib(nibName: EditTextFieldCell.identifier, bundle: nil)
        registrationTableView.register(nib, forCellReuseIdentifier: EditTextFieldCell.identifier)
        let nib2 = UINib(nibName: TermsConditionsCell.identifier, bundle: nil)
        registrationTableView.register(nib2, forCellReuseIdentifier: TermsConditionsCell.identifier)
    }
    
    private func validateInputFields() -> Bool {
        
        //Check field validations
        userParametersErrors.name = Validator().validateUserName(userParameters.name)
        userParametersErrors.mobile = Validator().validateMobile(userParameters.mobile)
        userParametersErrors.email = Validator().validateEmail(userParameters.email)
        userParametersErrors.password = Validator().validatePassword(userParameters.password)
        
        return userParametersErrors.name.isEmpty && userParametersErrors.mobile.isEmpty && userParametersErrors.email.isEmpty && userParametersErrors.password.isEmpty
    }
    
    private func getInputFieldError() -> String {
        
        guard userParametersErrors.name.isEmpty else { return userParametersErrors.name }
        guard userParametersErrors.mobile.isEmpty else { return userParametersErrors.mobile }
        guard userParametersErrors.email.isEmpty else { return userParametersErrors.email }
        guard userParametersErrors.password.isEmpty else { return userParametersErrors.password }
        
        return ""
    }
}

//MARK: - UITableView Delegate -

extension Registration: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 6 {
            return UITableViewAutomaticDimension
        }
        return 65 // 12 + 50 + 13
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 6 {
            return UITableViewAutomaticDimension
        }
        return 65 // 12 + 50 + 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: EditTextFieldCell.identifier, for: indexPath) as! EditTextFieldCell
        
        //Setup cell values
        cell.textField.delegate = self
        cell.textField.tag = 100 + indexPath.row
        currentTextField = cell.textField
        
        switch indexPath.row {
        case 0:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.name, placeHolderText: "user_name".localized, image: #imageLiteral(resourceName: "icon-user"))
        case 1:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.mobile, placeHolderText: "mobile".localized, image: #imageLiteral(resourceName: "icon-mobile"))
        case 2:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.email, placeHolderText: "email".localized, image: #imageLiteral(resourceName: "icon-email"))
        case 3:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.password, placeHolderText: "password".localized, image: #imageLiteral(resourceName: "icon-password"))
        case 4:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.licenseNumber, placeHolderText: "driver_license_no".localized, image: #imageLiteral(resourceName: "icon-driver-license-no"))
        case 5:
            UtilityFunctions().setTextField(cell.textField, text: userParameters.vehicleRegistrationNumber, placeHolderText: "vehicle_registration_no".localized, image: #imageLiteral(resourceName: "icon-vehicle-registration-no"))
        case 6:
            //Create cell
            let termsCell = tableView.dequeueReusableCell(withIdentifier: TermsConditionsCell.identifier, for: indexPath) as! TermsConditionsCell
            
            //Setup cell
            termsCell.titleLabel.text = "terms_conditions_message".localized

            //Return cell
            return termsCell
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
        
        switch textField.superview!.tag {
        case 100:
            textField.autocorrectionType = .yes
        case 101:
            textField.keyboardType = .numberPad
        case 102:
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
        case 100, 102:
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
        case 104:
            userParameters.licenseNumber = textField.text!
        case 105:
            userParameters.vehicleRegistrationNumber = textField.text!
        default:
            break
        }
    }
}
