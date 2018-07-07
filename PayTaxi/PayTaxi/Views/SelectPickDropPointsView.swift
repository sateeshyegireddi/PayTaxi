//
//  SelectPickDropPointsView.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 22/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

protocol SelectPickDropPointsViewDelegate {
    
    func moreDestinationsDidTap()
    func pickDropPointDidSelect(_ pickup: Bool)
}

class SelectPickDropPointsView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var pickPointView: UIView!
    @IBOutlet weak var pickPointButton: UIButton!
    @IBOutlet weak var dropPointView: UIView!
    @IBOutlet weak var dropPointButton: UIButton!
    @IBOutlet weak var elementHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    fileprivate weak var vc: UIViewController!
    fileprivate weak var view: UIView!
    var delegate: SelectPickDropPointsViewDelegate?
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, inView vc: UIViewController) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.vc = vc
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }
    
    //MARK: - View
    private func xibSetup(frame: CGRect) {
        
        view = loadViewFromNib()
        
        //Adjust the view size for iPhone 6 and iPhone 6 plus
        view.frame = frame
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SelectPickDropPointsView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    //MARK: - Actions
    @IBAction func moreDestinationsButtonTapped(_ sender: UIButton) {
    
        delegate?.moreDestinationsDidTap()
    }
    
    @IBAction func pickupPointButtonTapped(_ sender: UIButton) {
    
        delegate?.pickDropPointDidSelect(sender == pickPointButton)
    }
    
    //MARK: - Functions
    private func setupUI() {
        
        //Setup view
        elementHeight.constant = UIScreen.main.bounds.width == 320 ? 45 : 50
        UtilityFunctions().addRoudedBorder(to: pickPointView, showCorners: true, borderColor: UIColor.clear, borderWidth: 0, showShadow: true)
        UtilityFunctions().addRoudedBorder(to: dropPointView, showCorners: true, borderColor: UIColor.clear, borderWidth: 0, showShadow: true)
        
        //Setup textFields
        pickPointButton.setTitle("current_location".localized, for: .normal)
        pickPointButton.titleLabel?.font = GlobalConstants.Fonts.verySmallText!
        pickPointButton.setTitleColor(GlobalConstants.Colors.tungesten, for: .normal)
        
        dropPointButton.setTitle("destination_please".localized, for: .normal)
        dropPointButton.titleLabel?.font = GlobalConstants.Fonts.verySmallText!
        dropPointButton.setTitleColor(GlobalConstants.Colors.tungesten, for: .normal)
    }
 }
