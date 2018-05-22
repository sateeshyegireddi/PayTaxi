//
//  SelectPickDropPointsView.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 22/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

protocol SelectPickDropPointsViewDelegate {
    
    func pickPointTextFieldDidChange(_ textField: UITextField)
    func dropPointTextFieldDidChange(_ textField: UITextField)
    func placeTextFieldDidBeginEditing(_ textField: UITextField)
    func placeTextFieldDidEndEditing(_ textField: UITextField)
}

class SelectPickDropPointsView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var pickPointView: UIView!
    @IBOutlet weak var pickPointTextField: UITextField!
    @IBOutlet weak var dropPointView: UIView!
    @IBOutlet weak var dropPointTextField: UITextField!
    
    //MARK: - Variables
    fileprivate weak var vc: UIViewController!
    fileprivate weak var view: UIView!
    var pickupPoint: Place!
    var dropPoint: Place!
    var delegate: SelectPickDropPointsViewDelegate?
    
    //MARK: - View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, inView vc: UIViewController) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.vc = vc
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }
    
    private func xibSetup(frame: CGRect) {
        
        view = loadViewFromNib()
        
        //Adjust the view size for iPhone 6 and iPhone 6 plus
        view.frame = frame
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        //Init
        pickupPoint = Place()
        dropPoint = Place()
        
        //Setup view
        UtilityFunctions().addRoudedBorder(to: pickPointView, showCorners: true, borderColor: UIColor.clear, borderWidth: 0, showShadow: true)
        UtilityFunctions().addRoudedBorder(to: dropPointView, showCorners: true, borderColor: UIColor.clear, borderWidth: 0, showShadow: true)
        
        //Setup textFields
        pickPointTextField.delegate = self
        dropPointTextField.delegate = self
        pickPointTextField.attributedPlaceholder = NSAttributedString(string: "current_location".localized, attributes: [NSAttributedStringKey.foregroundColor: GlobalConstants.Colors.tungesten])
        dropPointTextField.attributedPlaceholder = NSAttributedString(string: "destination".localized, attributes: [NSAttributedStringKey.foregroundColor: GlobalConstants.Colors.tungesten])
        pickPointTextField.textColor = GlobalConstants.Colors.tungesten
        dropPointTextField.textColor = GlobalConstants.Colors.tungesten
        pickPointTextField.addTarget(self, action: #selector(pickPointTextFieldDidChange(_:)), for: .editingChanged)
        dropPointTextField.addTarget(self, action: #selector(dropPointTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SelectPickDropPointsView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    //MARK: - Actions
    @objc func pickPointTextFieldDidChange(_ textField: UITextField) {
        
        delegate?.pickPointTextFieldDidChange(textField)
    }
    
    @objc func dropPointTextFieldDidChange(_ textField: UITextField) {
        
        delegate?.dropPointTextFieldDidChange(textField)
    }
 }

//MARK: - UITextField Delegate
extension SelectPickDropPointsView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
        delegate?.placeTextFieldDidBeginEditing(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == pickPointTextField {
            pickupPoint.title = pickPointTextField.text!
        } else {
            dropPoint.title = dropPointTextField.text!
        }
        delegate?.placeTextFieldDidEndEditing(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
