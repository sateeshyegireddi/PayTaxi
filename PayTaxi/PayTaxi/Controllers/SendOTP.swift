//
//  SendOTP.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 23/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class SendOTP: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var otpImageView: UIImageView!
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var otpMessageLabel: UILabel!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var mobileTextField: PTTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    //MARK: - Variables
    var countryCode: String!
    var mobile: String!
    var mobileNumberError: String!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init Variables
        countryCode = "India (+91)"
        mobile = ""
        mobileNumberError = ""
        
        //Add notification listener for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        //Setup basic UI
        setupUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        closeKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func countryButtonTapped(_ sender: UIButton) {
    
        closeKeyboard()
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        //Hide keyboard
        closeKeyboard()
        
        //Validate fields
        let isFieldsValid = validateInputFields()
        
        //Call login API service if all fields are valid
        if isFieldsValid {
            
            //Hide error pop-over message
            UtilityFunctions().hideErrorView(on: self)
            
            let countryCode = "+91"

            //Move user to send OTP screen
            OpenScreen().verifyOTP(self, for: countryCode + " " + mobile)

        } else {
            
            //Get error message
            let error = getInputFieldError()
            
            //Show error pop-over message to user
            UtilityFunctions().showErrorView(on: self, error: error.message, image: error.image)
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
    
    //MARK: - Validations
    private func validateInputFields() -> Bool {
        
        //Check field validations
        mobileNumberError = Validator().validateMobile(mobile)
        
        return mobileNumberError.isEmpty
    }
    
    private func getInputFieldError() -> (message: String, image: UIImage?) {
        
        guard mobileNumberError.isEmpty else { return (mobileNumberError, #imageLiteral(resourceName: "icon-mobile-white")) }
        
        return ("", nil)
    }
    
    //MARK: - Functions
    func setupUI() {
        
        //Add topView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self, title: "", enableBack: true)
        view.addSubview(topView)
        
        //Setup imageView
        overlayImageView.image = #imageLiteral(resourceName: "dots-background")
        otpImageView.image = #imageLiteral(resourceName: "icon-otp")
        
        //Setup label
        UtilityFunctions().setStyleForLabel(otpLabel,
                                            text: "otp".localized,
                                            textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.bigTitleText!)
        UtilityFunctions().setStyleForLabel(otpMessageLabel,
                                            text: "otp_sent_message".localized,
                                            textColor: GlobalConstants.Colors.iron,
                                            font: GlobalConstants.Fonts.lightText!)
        UtilityFunctions().setStyleForLabel(countryLabel,
                                            text: countryCode,
                                            textColor: GlobalConstants.Colors.oceanblue,
                                            font: GlobalConstants.Fonts.textFieldText!)
        
        //Setup textField
        UtilityFunctions().setTextField(mobileTextField,
                                        text: mobile,
                                        placeHolderText: "mobile".localized,
                                        image: #imageLiteral(resourceName: "icon-mobile"),
                                        validText: mobile.isEmpty, delegate: self, tag: 100)
        
        //Setup button
        UtilityFunctions().addRoudedBorder(to: countryView, borderColor: GlobalConstants.Colors.mercury, borderWidth: 1)
        UtilityFunctions().setStyle(for: sendButton, text: "send".localized, backgroundColor: GlobalConstants.Colors.aqua)
    }
}

//MARK: - PTTextField Delegate -
extension SendOTP: PTTextFieldDelegate {
    
    func PTTextFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.keyboardType = .numberPad
    }
    
    func PTTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return newString.count < 11
    }
    
    func PTTextFieldDidEndEditing(_ textField: UITextField) {
        
        mobile = textField.text!
    }
}
