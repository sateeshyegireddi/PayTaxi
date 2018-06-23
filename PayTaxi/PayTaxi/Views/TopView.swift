//
//  TopView.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 23/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class TopView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var elementHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    fileprivate weak var vc: UIViewController!
    fileprivate weak var view: UIView!
    var title: String!
    var enableBack: Bool!
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(origin: CGPoint.zero, size: frame.size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, on vc: UIViewController, title text: String, enableBack back: Bool) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        self.vc = vc
        self.title = text
        self.enableBack = back
        self.setupUI()
    }
    
    //MARK: - View
    private func xibSetup(frame: CGRect) {
        
        view = loadViewFromNib()
        
        //Adjust view size for all different screen sizes
        view.frame = frame
        
        //Add custom subview on top of our view
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TopView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupUI() {
        
        //Setup view
        view.backgroundColor = UIColor.clear
        
        //Setup labels
        titleLabel.font = GlobalConstants.Fonts.labelMediumText!
        titleLabel.textColor = GlobalConstants.Colors.tungesten
        titleLabel.text = title
        
        //Setup buttons
        elementHeight.constant = UIScreen.main.bounds.width == 320 ? 45 : 50
        view.layoutIfNeeded()
        leftButton.backgroundColor = GlobalConstants.Colors.blue
        leftButton.setImage(enableBack ? #imageLiteral(resourceName: "icon-back-arrow-white") : #imageLiteral(resourceName: "icon-menu"), for: .normal)
        UtilityFunctions().addRoundness(to: [.topRight, .bottomRight], for: leftButton)
        
        rightButton.isHidden = enableBack
        rightButton.backgroundColor = GlobalConstants.Colors.blue
        rightButton.setImage(#imageLiteral(resourceName: "icon-notifications"), for: .normal)
        UtilityFunctions().addRoundness(to: [.topLeft, .bottomLeft], for: rightButton)
    }
    
    //MARK: - Actions
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        
        //Move back if the viewController is in navigation stack
        if enableBack {
            
            if let navigation = vc.navigationController {
                navigation.popViewController(animated: false)
            } else {
                vc.dismiss(animated: false, completion: nil)
            }
        } else {
            
            //TODO: Open to Menu
        }
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        
        //TODO: Redirect to Notifications
    }
    
    //MARK: - Functions
    
}
