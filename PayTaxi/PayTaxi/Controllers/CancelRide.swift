//
//  CancelRide.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 07/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class CancelRide: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var cancelRideTableView: UITableView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var othersTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK: - Variables
    var selectedRow: Int!
    var isOtherReason: Bool!
    var otherReason: String!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init Variables
        selectedRow = -1
        isOtherReason = false
        otherReason = ""
        
        // Setup View
        setupView()
        
        // Register Cells
        registerCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        closeKeyboard()
    }
    
    //MARK: - Actions
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        if isOtherReason {
            
            isOtherReason = false
            selectedRow = -1
            cancelRideTableView.reloadData()
            showOthersTextView(false)
            closeKeyboard()
        }
    }
    
    //MARK: - Keyboard Delegate Method
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        //Move screen little bit up to show fields in 5S
        if UIScreen.main.bounds.width <= 375 {
            
            //Call function to move the view up
            UtilityFunctions().keyboardWillShow(notification, inView: self.view, percent: 0.2)
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
    private func registerCells() {
    
        let nib = UINib(nibName: CancelRideCell.identifier, bundle: nil)
        cancelRideTableView.register(nib, forCellReuseIdentifier: CancelRideCell.identifier)
    }
    
    private func showOthersTextView(_ show: Bool) {
        
        othersTextView.text = "text_here".localized
        overlayView.isHidden = !show
        cancelRideTableView.isHidden = show
    }
    
    private func setupView() {
        
        //Add TopView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self,
                              title: "cancel_reason".localized, enableBack: true, showNotifications: false)
        topView.leftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(topView)
        
        //Setup View
        showOthersTextView(false)
        overlayView.accessibilityIdentifier = "RideHistoryView"
        UtilityFunctions().addRoudedBorder(to: overlayView, showCorners: true, borderColor: GlobalConstants.Colors.megnisium,
                                           borderWidth: 0.5, showShadow: false, shadowColor: GlobalConstants.Colors.mercury)

        //Setup ImageView
        overlayImageView.image = #imageLiteral(resourceName: "dots-background")
        
        //Setup TextView
        othersTextView.textColor = GlobalConstants.Colors.tungesten
        othersTextView.font = GlobalConstants.Fonts.smallMediumText!
        othersTextView.text = "text_here".localized
        
        //Setup Button
        UtilityFunctions().setStyle(for: submitButton, text: "submit".localized,
                                    backgroundColor: GlobalConstants.Colors.orange)
    }
}

//MARK: - UITableView Delegate -
extension CancelRide: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CancelRideCell.identifier,
                                                 for: indexPath) as! CancelRideCell
        
        //Setup cell values
        cell.cancelButton.setTitle("Reason \(indexPath.row + 1)", for: .normal)
        cell.cancelButton.isSelected = (indexPath.row == selectedRow)
        
        //Return cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isOtherReason = indexPath.row == 5
        selectedRow = indexPath.row
        cancelRideTableView.reloadData()
        showOthersTextView(isOtherReason)
    }
}

//MARK: - UITextView Delegate -
extension CancelRide: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        //Clear the placeholder text
        if textView.text == "text_here".localized {
            textView.text = ""
        }
        
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //Disable emojis
        if textView.textInputMode?.primaryLanguage == nil || textView.textInputMode?.primaryLanguage == "emoji" {
            return false
        }
        
        let newString = NSString(string: textView.text).replacingCharacters(in: range, with: text)
        return newString.count <= 200
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        otherReason = textView.text
    }
}
