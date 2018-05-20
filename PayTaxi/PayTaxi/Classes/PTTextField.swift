//
//  PTTextField.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 20/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

public protocol PTTextFieldDelegate {
    
    func PTTextFieldDidBeginEditing(_ textField: UITextField)
    func PTTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func PTTextFieldDidEndEditing(_ textField: UITextField)
}

@IBDesignable
class PTTextField: UIView {
    
    //MARK: - Variables
    fileprivate var textField: UITextField?
    fileprivate var imageView: UIImageView?
    fileprivate var borderView: UIView?
    
    var delegate: PTTextFieldDelegate?
    
    //MARK: - Inspectable Variables
    @IBInspectable public var borderColor: UIColor = UIColor.gray {
        didSet {
            borderView?.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var placeHolderText: String = "" {
        didSet {
            textField?.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedStringKey.foregroundColor: GlobalConstants.Colors.megnisium])
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor.black {
        didSet {
            textField?.textColor = textColor
        }
    }
    
    @IBInspectable public var text: String = "" {
        didSet {
            textField?.text = text
        }
    }
    
    @IBInspectable public var isSecureEntry: Bool = false {
        didSet {
            textField?.isSecureTextEntry = isSecureEntry
        }
    }
    
    @IBInspectable public var margin: CGFloat = 20 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable public var image: UIImage? = nil {
        didSet {
            imageView?.image = image
        }
    }
    
    @IBInspectable public var enableUserInteraction: Bool = true {
        didSet {
            textField?.isUserInteractionEnabled = enableUserInteraction
        }
    }
    
    public func textFieldbecomeFirstResponder() {
        
        let _ = textField?.becomeFirstResponder()
    }
    
    //MARK: - View Init-Setup
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public func layoutSubviews() {
        
        borderView?.frame = bounds
        imageView?.frame = CGRect(x: margin, y: 0, width: 25, height: bounds.height)
        textField?.frame = CGRect(x: imageView!.frame.origin.x + imageView!.bounds.width + 10,
                                  y: 0,
                                  width: bounds.width - (margin * 2) - (imageView!.frame.origin.x + 10),
                                  height: bounds.height)
    }
    
    func cleanViews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    func setup() {
        
        //Clean views
        cleanViews()
        
        //Add border view
        borderView = UIView(frame: bounds)
        borderView?.layer.borderWidth = 1
        borderView?.layer.cornerRadius = bounds.height / 2
        borderView?.layer.masksToBounds = true
        addSubview(borderView!)
        
        //Add imageView
        imageView = UIImageView(frame: CGRect(x: margin, y: 0, width: 25, height: bounds.height))
        imageView?.contentMode = .center
        addSubview(imageView!)
        
        //Add textField
        textField = UITextField(frame: CGRect(x: imageView!.frame.origin.x + imageView!.bounds.width + 10,
                                              y: 0,
                                              width: bounds.width - (margin * 2) - (imageView!.frame.origin.x + 10),
                                              height: bounds.height))
        textField?.delegate = self
        textField?.borderStyle = .none
        textField?.font = GlobalConstants.Fonts.textFieldText!
        addSubview(textField!)
        
    }
}

//MARK: - UITextField Delegate
extension PTTextField: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        delegate?.PTTextFieldDidBeginEditing(textField)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Disable emojis
        if textField.textInputMode?.primaryLanguage == nil || textField.textInputMode?.primaryLanguage == "emoji" {
            return false
        }
        
        //let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        guard delegate == nil else {
            return (delegate?.PTTextField(textField, shouldChangeCharactersIn: range, replacementString: string))!
        }
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        delegate?.PTTextFieldDidEndEditing(textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
