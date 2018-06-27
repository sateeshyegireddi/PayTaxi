//
//  VerifyOTP.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 23/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class VerifyOTP: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var otpImageView: UIImageView!
    @IBOutlet weak var verifyOTPLabel: UILabel!
    @IBOutlet weak var otpMessageLabel: UILabel!
    @IBOutlet weak var mobileButton: UIButton!
    @IBOutlet var otpTextFields: [UITextField]!
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var otpTimerLabel: UILabel!
    @IBOutlet weak var otpNotRecieveLabel: UILabel!
    @IBOutlet weak var resendOTPButton: UIButton!
    @IBOutlet weak var onCallOTPButton: UIButton!
    
    //MARK: - Variables
    var mobile: String! = ""
    var digits: [String]!
    var time: String!
    var currentTextField: UITextField?
    var otpError: String!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Init Variables
        digits = Array.init(repeating: "", count: 6)
        time = ""
        otpError = ""
        
        //Setup basic UI
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func mobileButtonTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func resendOTPButtonTapped(_ sender: UIButton) {
    
    
    }
    
    @IBAction func onCallOTPButtonTapped(_ sender: UIButton) {
        
        
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        if currentTextField != nil {
            if let newTextField = view.viewWithTag(currentTextField!.text!.isEmpty ? textField.tag - 1 : textField.tag + 1) as? UITextField {
                newTextField.becomeFirstResponder()
            }
        }
    }
    
    //MARK: - Validations
    private func validateInputFields() -> Bool {
        
        //Check field validations
        let otp = digits.joined(separator: "")
        otpError = Validator().validateOTP(otp)
        
        return otpError.isEmpty
    }
    
    private func getInputFieldError() -> (message: String, image: UIImage?) {
        
        guard otpError.isEmpty else { return (otpError, #imageLiteral(resourceName: "icon-mobile-white")) }
        
        return ("", nil)
    }
    
    //MARK: - Functions
    func setupUI() {
        
        //Add topView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self, title: "", enableBack: true, showNotifications: false)
        view.addSubview(topView)
        
        //Setup imageView
        overlayImageView.image = #imageLiteral(resourceName: "dots-background")
        otpImageView.image = #imageLiteral(resourceName: "icon-otp")
        
        //Setup label
        UtilityFunctions().setStyleForLabel(verifyOTPLabel,
                                            text: "verification_code".localized,
                                            textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.bigTitleText!)
        UtilityFunctions().setStyleForLabel(otpMessageLabel,
                                            text: "verify_otp_message".localized,
                                            textColor: GlobalConstants.Colors.iron,
                                            font: GlobalConstants.Fonts.lightText!)
        UtilityFunctions().setStyleForLabel(otpLabel,
                                            text: "one_time_password".localized,
                                            textColor: GlobalConstants.Colors.iron,
                                            font: GlobalConstants.Fonts.lightText!)
        UtilityFunctions().setStyleForLabel(otpTimerLabel,
                                            text: "",
                                            textColor: GlobalConstants.Colors.iron,
                                            font: GlobalConstants.Fonts.lightText!)
        UtilityFunctions().setStyleForLabel(otpNotRecieveLabel,
                                            text: "otp_not_recieve_message".localized,
                                            textColor: GlobalConstants.Colors.iron,
                                            font: GlobalConstants.Fonts.textFieldBoldText!)
        
        //Setup textField
        var i = 0
        let width = (UIScreen.main.bounds.width - 125) / 6
        
        //Looping through each textField
        for textField in otpTextFields {
            
            //Add round corners
            textField.textColor = GlobalConstants.Colors.oceanblue
            textField.font = GlobalConstants.Fonts.textFieldText
            textField.layer.cornerRadius = width / 2
            textField.layer.masksToBounds = true
            textField.layer.borderColor = GlobalConstants.Colors.mercury.cgColor
            textField.layer.borderWidth = 1
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            //Assign tag
            textField.tag = 100 + i
            textField.delegate = self
            i += 1
        }
        
        //Setup button
        mobileButton.setTitle(mobile, for: .normal)
        mobileButton.setTitleColor(GlobalConstants.Colors.iron, for: .normal)
        mobileButton.titleLabel?.font = GlobalConstants.Fonts.smallBoldText!
        UtilityFunctions().setStyle(for: resendOTPButton, text: "resend_code".localized, backgroundColor: GlobalConstants.Colors.aqua)
        UtilityFunctions().setStyle(for: onCallOTPButton, text: "otp_on_call".localized, backgroundColor: GlobalConstants.Colors.aqua)
    }
}

//MARK: - UITextField Delegate -
extension VerifyOTP: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        currentTextField = textField
        textField.keyboardType = .numberPad
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return newString.count < 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        digits[textField.tag - 100] = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

class TextField: UITextField {
    
    override func deleteBackward() {
        
        super.deleteBackward()
    }
}
