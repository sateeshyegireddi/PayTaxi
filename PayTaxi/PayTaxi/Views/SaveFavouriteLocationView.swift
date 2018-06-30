//
//  SaveFavouriteLocation.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 27/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

public protocol SaveFavouriteLocationViewDelegate {
    
    func saveDestinationLocation(_ location: String)
}

class SaveFavouriteLocationView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var othersLabel: UILabel!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var othersTextField: PTTextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var seperatorLabel: UIImageView!
    @IBOutlet weak var othersTextFieldTop: NSLayoutConstraint!
    @IBOutlet weak var othersTextFieldHeight: NSLayoutConstraint!

    //MARK: - Variables
    private weak var vc: UIViewController!
    private var view: UIView!
    fileprivate var otherString: String!
    fileprivate var otherError: String!
    var delegate: SaveFavouriteLocationViewDelegate?
    
    //MARK: - Initialization
    init(frame: CGRect, on viewController: UIViewController) {
        super.init(frame: frame)
        xibSetup(CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.vc = viewController
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - View
    private func xibSetup(_ frame: CGRect) {
        
        //Load the nib from xib file
        view = loadViewFromNib()
        
        //Adjust the frame for all different screen sizes
        view.frame = frame
        
        //Add custom subView on top of our view
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SaveFavouriteLocationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    //MARK: - Actions
    @IBAction func tapOnView(_ sender: UITapGestureRecognizer) {
    
        //Hide keyboard if user is tapped out of content view
        if sender.state == .ended { removeViewFromSuperView() }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        delegate?.saveDestinationLocation("")
        closeKeyboard()
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        
        closeKeyboard()
        showOthersTextField(false)
        resetButtonImages()
        sender.setImage(#imageLiteral(resourceName: "icon-home-select"), for: .normal)
    }
    
    @IBAction func workButtonTapped(_ sender: UIButton) {

        closeKeyboard()
        showOthersTextField(false)
        resetButtonImages()
        sender.setImage(#imageLiteral(resourceName: "icon-work-select"), for: .normal)
    }
    
    @IBAction func othersButtonTapped(_ sender: UIButton) {
        
        showOthersTextField(true)
        resetButtonImages()
        sender.setImage(#imageLiteral(resourceName: "icon-heart-select"), for: .normal)
        othersTextField.textFieldBecomeFirstResponder()
    }
    
    //MARK: - Keyboard Delegate Method
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        //Call function to move the view up
        UtilityFunctions().keyboardWillShow(notification, inView: self.view, percent: 0.96)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        //Call function to move the view back down
        UtilityFunctions().keyboardWillHide(notification, inView: self.view)
    }
    
    func closeKeyboard() {
        
        self.endEditing(true)
    }
    
    func removeViewFromSuperView() {
    
        closeKeyboard()
        self.removeFromSuperview()
    }
    
    //MARK: - Functions
    private func setupView() {
        
        //Init Variables
        otherString = ""
        otherError = ""
        
        //Setup view
        backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        showOthersTextField(false)
        
        //Setup ImageView
        overlayImageView.image = #imageLiteral(resourceName: "cab-select-background")
        
        //Setup Label
        homeLabel.text = "home".localized
        workLabel.text = "work".localized
        othersLabel.text = "other".localized
        seperatorLabel.backgroundColor = GlobalConstants.Colors.silver

        //Setup Button
        UtilityFunctions().setStyle(for: saveButton, text: "save".localized, backgroundColor: GlobalConstants.Colors.green)
        
        //Setup TextField
        UtilityFunctions().setTextField(othersTextField,
                                        text: otherString,
                                        placeHolderText: "other".localized,
                                        image:#imageLiteral(resourceName: "icon-heart"),
                                        validText: otherError.isEmpty, delegate: self, tag: 100)
        othersTextField.imageViewContentMode = .scaleAspectFit
        
        //Add notification listener for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func showOthersTextField(_ show: Bool) {
        
        othersTextField.isHidden = !show
        othersTextFieldTop.constant = show ? 20 : 0
        let height: CGFloat = UIScreen.main.bounds.width == 320 ? 50 : 45
        othersTextFieldHeight.constant = show ? height : 0
    }
    
    private func resetButtonImages() {
        
        homeButton.setImage(#imageLiteral(resourceName: "icon-home"), for: .normal)
        workButton.setImage(#imageLiteral(resourceName: "icon-work"), for: .normal)
        othersButton.setImage(#imageLiteral(resourceName: "icon-heart"), for: .normal)
    }
}

//MARK: - PTTextField Delegate -
extension SaveFavouriteLocationView: PTTextFieldDelegate {
    
    func PTTextFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func PTTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return newString.count <= 20
    }
    
    func PTTextFieldDidEndEditing(_ textField: UITextField) {
        
        otherString = textField.text!
    }
}
