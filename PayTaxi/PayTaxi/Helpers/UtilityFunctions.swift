//
//  UtilityFunctions.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class UtilityFunctions: NSObject {

    //MARK: - Internet functions
    func connectionToInternetIsAvailable() -> Bool {
        
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
    func getNetworkType() -> String {
        
        let reachability: Reachability = Reachability.forInternetConnection()
        switch reachability.currentReachabilityStatus().rawValue {
        case 1:
            return "Wifi"
        case 2:
            return "Cellular"
        default:
            return "Unknow"
        }
    }
    
    func getNetworkStatus() -> Int {
        
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus
    }
    
    func getIPAddressOfNetworkInterface() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    
    //MARK: - General Functions
    func setAutoLogin(_ bool: Bool) {
        
        if bool {
            UserDefaults.standard.set(true, forKey: GlobalConstants.UserDefaultsConstants.kAutoLogin)
        } else {
            UserDefaults.standard.set(false, forKey: GlobalConstants.UserDefaultsConstants.kAutoLogin)
        }
        UserDefaults.standard.synchronize()
    }
    
    func isAutoLogin() -> Bool {
        
        let isAutoLogin = UserDefaults.standard.bool(forKey: GlobalConstants.UserDefaultsConstants.kAutoLogin)
        return isAutoLogin
    }
    
    func saveLanguage(_ lang: String) {
        
        UserDefaults.standard.set(lang, forKey: GlobalConstants.Localisation.key)
        UserDefaults.standard.synchronize()
    }
    
    func currentLanguage() -> String {
        
        return UserDefaults.standard.string(forKey: GlobalConstants.Localisation.key) ?? GlobalConstants.Localisation.english
    }
    
    //MARK: - Keychain
    func clearKeychainData() {
        
        do {
            try Keychain.standard.clearKeyChain()
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func saveApiToken(_ token: String) {
        
        do {
            try Keychain.standard.saveApiToken(token)
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func getApiToken() -> String {
        
        do {
            return try Keychain.standard.getApiToken()
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        return ""
    }
    
    func saveAuthToken(_ token: String) {
        
        do {
            try Keychain.standard.saveAuthToken(token)
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func getAuthToken() -> String {
        
        do {
            return try Keychain.standard.getAuthToken()
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        return ""
    }
    
    func saveSessionId(_ sessionId: String) {
        
        do {
            try Keychain.standard.saveApiToken(sessionId)
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func getSessionId() -> String {
        
        do {
            return try Keychain.standard.getApiToken()
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        return ""
    }
    
    func saveUser(_ user: User) {
        
        do {
            try Keychain.standard.saveUser(user)
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func getUser() -> User? {
        
        do {
            return try Keychain.standard.getUser()
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        return nil
    }
    
    func saveDeviceToken(_ token: String) {
        
        UserDefaults.standard.set(token, forKey: GlobalConstants.UserDefaultsConstants.kDeviceToken)
        UserDefaults.standard.synchronize()
    }
    
    func deviceToken() -> String {
        
        return UserDefaults.standard.string(forKey: GlobalConstants.UserDefaultsConstants.kDeviceToken) ?? ""
    }
    
    //MARK: - Styles
    func addRoudedBorder(to view: UIView, borderColor color: UIColor, borderWidth width: CGFloat) {
        
        view.layer.cornerRadius = (view is UIButton) ? GlobalConstants.View.buttonCornerRadius : GlobalConstants.View.viewCornerRadius
        view.layer.masksToBounds = true
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
    }
    
    func addRoudedBorder(to view: UIView, showCorners corners: Bool, borderColor color: UIColor, borderWidth width: CGFloat, showShadow show: Bool) {
        
        view.layer.masksToBounds = false
        
        //Corners
        if corners {
            view.layer.cornerRadius = GlobalConstants.View.viewCornerRadius
        }
        
        //Border
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width

        //Shadow
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.15
    }
    
    func addAttributedFont(for button: UIButton, till index: Int) {
        
        let attributedString = NSMutableAttributedString(string: button.titleLabel!.text!)
        attributedString.addAttribute(NSAttributedStringKey.font, value: GlobalConstants.Fonts.lightText!, range: NSRange(location: 0, length: index))
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: GlobalConstants.Colors.iron, range: NSRange(location: 0, length: index))
        attributedString.addAttribute(NSAttributedStringKey.font, value: GlobalConstants.Fonts.textFieldBoldText!, range: NSRange(location: index + 1, length: button.titleLabel!.text!.count - index - 1))
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: GlobalConstants.Colors.planetblue, range: NSRange(location: index + 1, length: button.titleLabel!.text!.count - index - 1))
        button.setAttributedTitle(attributedString, for: UIControlState.normal)
    }
    
    func setGradientLayer(for view: UIView, fromColor color1: UIColor, toColor color2: UIColor) {
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.startPoint = CGPoint(x: 1.0, y: 0.2)
        layer.endPoint = CGPoint(x: 1.0, y: 1)
        layer.colors = [color1.cgColor, color2.cgColor]
        //layer.locations = [NSNumber(value: 0.0), NSNumber(value: 0.6), NSNumber(value: 1.0)]
        view.layer.addSublayer(layer)
    }
    
    func setStyleForLabel(_ label: UILabel, text title: String, textColor color: UIColor, font fontType: UIFont) {
        
        label.text = title
        label.textColor = color
        label.font = fontType
    }
    
    //MARK: - Model
    func parseDouble(in dict: [String: Any]?, for key: String) -> Double {
        
        var double = 0.00
        
        if let value = dict?[key] as? String {
            double = Double(value) ?? 0
        } else if let value = dict?[key] as? Int {
            double = Double(value)
        } else if let value = dict?[key] as? Double {
            double = value
        }
        
        return double
    }
    
    func parseInt(in dict: [String: Any]?, for key: String) -> Int {
        
        var int = 0
        
        if let value = dict?[key] as? String {
            int = Int(value) ?? 0
        } else if let value = dict?[key] as? Int {
            int = Int(value)
        }
        
        return int
    }
    
    func parseString(in dict: [String: Any]?, for key: String) -> String {
        
        var str = ""
        
        if let value = dict?[key] as? String {
            str = value
        } else if let value = dict?[key] as? Int {
            str = String(value)
        }
        
        return str
    }
    
    //MARK: - Custom UI
    
    func setTextField(_ textField: PTTextField, text textString: String, placeHolderText placeHolder: String, image leftImage: UIImage?, validText valid: Bool, delegate vc: UIViewController, tag tagValue: Int) {
        
        textField.margin = 15
        textField.borderColor = GlobalConstants.Colors.mercury
        textField.textColor = GlobalConstants.Colors.oceanblue
        textField.text = textString
        textField.invalidText = !valid
        textField.placeHolderText = placeHolder
        textField.image = leftImage
        textField.delegate = vc as? PTTextFieldDelegate
        textField.tag = tagValue
    }
    
    func showInternetNotAvailable() {
        
        if let vc = UIApplication.topViewController() {
            let noConnectionView = NoConnectionView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: UIScreen.main.bounds.width,
                                                                  height: UIScreen.main.bounds.height == 812 ? 73 : 50),
                                                    inView: vc)
            noConnectionView.alpha = 0.0
            vc.view.addSubview(noConnectionView)
            UIView.animate(withDuration: 1.0, animations: {
                noConnectionView.alpha = 1.0
            }) { (finished) in
                noConnectionView.alpha = 1.0
            }
        }
    }
    
    //MARK: - Keyboard Functions
    func keyboardWillShow(_ notification: NSNotification, inView: UIView, percent: CGFloat) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            inView.frame.origin.y = 0 - keyboardSize.height * percent
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification, inView: UIView) {
        
        inView.frame.origin.y = 0
    }
    
    //MARK: - Native UI
    func showSimpleAlert(OnViewController vc: UIViewController, Message message: String) {
        
        //Create alertController object with specific message
        let alertController = UIAlertController(title: GlobalConstants.Constants.appName, message: message, preferredStyle: .alert)
        
        //Add OK button to alert and dismiss it on action
        let alertAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        
        //Show alert to user
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func showSimpleAlert(OnViewController vc: UIViewController, Message message: String, Handler handler: @escaping (_ action: UIAlertAction) -> Void) {
        
        //Create alertController object with specific message
        let alertController = UIAlertController(title: GlobalConstants.Constants.appName, message: message, preferredStyle: .alert)
        
        //Add OK button to alert and dismiss it on action
        let alertAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
            
            //Call Action handler
            handler(action)
        }
        alertController.addAction(alertAction)
        
        //Show alert to user
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func showSimpleAlertWithCancel(OnViewController vc: UIViewController, Message message: String, Handler handler: @escaping (_ action: UIAlertAction) -> Void) {
        
        //Create alertController object with specific message
        let alertController = UIAlertController(title: GlobalConstants.Constants.appName, message: message, preferredStyle: .alert)
        
        //Add OK button to alert and dismiss it on action
        let alertAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
            
            //Call Action handler
            handler(action)
        }
        alertController.addAction(alertAction)
        
        //Add Cancel button to alert and dismiss it on action
        let alertAction2 = UIAlertAction(title: "cancel".localized, style: .default) { (action) in
        }
        alertController.addAction(alertAction2)
        
        //Show alert to user
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    func showActionSheet(on viewController: UIViewController, withTitle title: String, andMessage message: String, firstActionTitle actionTitle1: String, andItsHandler handler1: @escaping (_ action: UIAlertAction) -> Void, secondActionTitle actionTitle2: String, andItsHandler handler2: @escaping (_ action: UIAlertAction) -> Void) {
        
        //Create an alert Controller of type action sheet
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        
        //Add first action
        let action1 = UIAlertAction.init(title: actionTitle1, style: .default, handler: { (action: UIAlertAction) in
            
            //Call Action handler
            handler1(action)
        })
        
        //Add second action
        let action2 = UIAlertAction.init(title: actionTitle2, style: .default, handler: { (action: UIAlertAction) in
            
            //Call Action handler
            handler2(action)
        })
        
        //Add cancel action
        let cancelAction = UIAlertAction.init(title: "cancel".localized, style: .cancel, handler: { (action: UIAlertAction) in
        })
        
        //Add actions to alert controller
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(cancelAction)
        
        //Present the alert controller on current view controller
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithTextField(OnViewController vc: UIViewController, message info: String, placeHolder holder: String, Handler handler: @escaping (_ textFieldText: String) -> Void) {
        
        //Create an alert Controller of type action sheet
        let alertController = UIAlertController.init(title: GlobalConstants.Constants.appName, message: info, preferredStyle: .alert)

        //Add textField to alertController
        alertController.addTextField { (textField) in
            textField.placeholder = holder
        }
        
        //Add OK button to alert and dismiss it on action
        let alertAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
            
            let textField = alertController.textFields![0] as UITextField
            handler(textField.text!)
        }
        alertController.addAction(alertAction)
        
        //Add Cancel button to alert and dismiss it on action
        let alertAction2 = UIAlertAction(title: "cancel".localized, style: .default) { (action) in
        }
        alertController.addAction(alertAction2)
                
        //Present the alert controller on current view controller
        vc.present(alertController, animated: true, completion: nil)
    }
}
