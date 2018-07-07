//
//  DriverInfoView.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 01/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class DriverInfoView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var imageOverlayView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var carNumberTextLabel: UILabel!
    @IBOutlet weak var carNumberLabel: UILabel!
    @IBOutlet weak var vehicleTypeTextLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var ratingTextLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var seperators: [UIImageView]!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var paymentTypeTextLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var estimateTextLabel: UILabel!
    @IBOutlet weak var estimatePriceLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var shareStatusButton: UIButton!
    @IBOutlet weak var overlayImageViewHeight: NSLayoutConstraint!   //459
    @IBOutlet var maxDistanceConstraints: [NSLayoutConstraint]!      //25
    @IBOutlet var minDistanceConstraints: [NSLayoutConstraint]!      //20
    @IBOutlet var imageViewHeights: [NSLayoutConstraint]!            //20
    @IBOutlet weak var shareButtonHeight: NSLayoutConstraint!        //45
    @IBOutlet var seperatorHeights: [NSLayoutConstraint]!            //01
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!             //50
    
    //MARK: - Variables
    private weak var vc: UIViewController!
    private weak var view: UIView!
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }
    
    init(frame: CGRect, on viewController: UIViewController) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        setupView()
        self.vc = viewController
    }
    
    //MARK: - View
    private func xibSetup(frame: CGRect) {
        
        //Load nib from the xib file
        view = loadViewFromNib()
        
        //Adjust the frame for all different screen sizes
        view.frame = frame
        
        //Add custom subView on top of our view
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DriverInfoView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    //MARK: - Actions
    @IBAction func shareButtonTapped(_ sender: UIButton) {
    
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
    
        
    }
    
    @IBAction func contactButtonTapped(_ sender: UIButton) {
    
        OpenScreen().rideComplete(vc)
    }
    
    @IBAction func shareStatusButtonTapped(_ sender: UIButton) {
    
        
    }
    
    @IBAction func swiped(_ sender: UISwipeGestureRecognizer) {
        
        if sender.state == .recognized {
            if sender.direction == .up {
                showDriverDetailsInfoView(true)
            } else if sender.direction == .down {
                showDriverDetailsInfoView(false)
            }
        }
    }
    
    
    //MARK: - Functions
    private func setupView() {
        
        //Adjust Spaces in-between UI Elements
        for space in maxDistanceConstraints {
            space.constant = UIScreen.main.bounds.width == 320 ? 20 : 25
        }
        
        for space in minDistanceConstraints {
            space.constant = UIScreen.main.bounds.width == 320 ? 15 : 20
        }
        shareButtonHeight.constant = UIScreen.main.bounds.width == 320 ? 40 : 45
        buttonHeight.constant = UIScreen.main.bounds.width == 320 ? 45 : 50
        
        //Setup View
        backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        overlayView.backgroundColor = UIColor.clear
        
        //Setup ImageView
        overlayImageView.image = #imageLiteral(resourceName: "driver-info-background")
        for seperator in seperators {
            seperator.backgroundColor = GlobalConstants.Colors.iron.withAlphaComponent(0.55)
        }
        for space in seperatorHeights {
            space.constant = 0.5
        }
        UtilityFunctions().addRoudness(to: imageOverlayView,
                                       borderColor: GlobalConstants.Colors.iron.withAlphaComponent(0.4))
        imageOverlayView.backgroundColor = UIColor.green
        UtilityFunctions().addRoudness(to: imageView,
                                       borderColor: GlobalConstants.Colors.iron.withAlphaComponent(0.4))

        //Setup Label
        UtilityFunctions().setStyleForLabel(nameLabel,
                                            text: "DRIVER NAME",
                                            textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.textFieldBoldText!)
        UtilityFunctions().setStyleForLabel(carNumberTextLabel,
                                            text: "car_number".localized,
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.tooSmallMediumText!)
        UtilityFunctions().setStyleForLabel(carNumberLabel,
                                            text: "AP 28 DJ 2000",
                                            textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().setStyleForLabel(vehicleTypeTextLabel,
                                            text: "vehicle_type".localized,
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.tooSmallMediumText!)
        UtilityFunctions().setStyleForLabel(vehicleTypeLabel,
                                            text: "MINI",
                                            textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().setStyleForLabel(ratingTextLabel,
                                            text: "rating".localized,
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.tooSmallMediumText!)
        UtilityFunctions().setStyleForLabel(ratingLabel,
                                            text: "4.5",
                                            textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().setStyleForLabel(homeLabel,
                                            text: "Source Location",
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().setStyleForLabel(destinationLabel,
                                            text: "Destination Location",
                                            textColor: GlobalConstants.Colors.orange,
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().setStyleForLabel(paymentTypeTextLabel,
                                            text: "payment_type".localized,
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.tooSmallMediumText!)
        UtilityFunctions().setStyleForLabel(paymentTypeLabel,
                                            text: "CASH",
                                            textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().setStyleForLabel(estimateTextLabel,
                                            text: "estimate".localized,
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.tooSmallMediumText!)
        UtilityFunctions().setStyleForLabel(estimatePriceLabel,
                                            text: "100.RS",
                                            textColor: GlobalConstants.Colors.green,
                                            font: GlobalConstants.Fonts.smallBoldText!)

        //Setup button
        UtilityFunctions().setStyle(for: cancelButton, text: "cancel".localized.uppercased(),
                                    backgroundColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55))
        UtilityFunctions().setStyle(for: contactButton, text: "contact".localized,
                                    backgroundColor: GlobalConstants.Colors.green)
        UtilityFunctions().setStyle(for: shareStatusButton, text: "share_status".localized,
                                    backgroundColor: GlobalConstants.Colors.green)
        layoutIfNeeded()
    }
    
    func showDriverDetailsInfoView(_ show: Bool) {
        
        //Adjust Constraint Constants
        
        //ImageView
        let showInfoHeight: CGFloat = UIScreen.main.bounds.width == 320 ? (459 - 45) : 459
        let infoHeight: CGFloat = UIScreen.main.bounds.width == 320 ? (237 - 15) : 237
        overlayImageViewHeight.constant = show ? showInfoHeight : infoHeight
        for height in imageViewHeights {
            height.constant = show ? 20 : 0
        }
        for space in seperatorHeights {
            space.constant = show ? 1 : 0
        }

        //Spacings
        for space in maxDistanceConstraints {
            let newHeight: CGFloat = UIScreen.main.bounds.width == 320 ? 20 : 25
            space.constant = show ? newHeight : 0
        }
        for space in minDistanceConstraints {
            let newHeight: CGFloat = UIScreen.main.bounds.width == 320 ? 15 : 20
            space.constant = show ? newHeight : 0
        }
    
        //Buttons
        let newShareHeight: CGFloat = UIScreen.main.bounds.width == 320 ? 40 : 45
        shareButtonHeight.constant = show ? newShareHeight : 0
        
        //Animation
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.overlayImageView.contentMode = show ? .redraw : .top
                        self.layoutIfNeeded()
        },
                       completion: {(finished) in
                        if !show { self.showUIElements(show) }
        })
        if show { showUIElements(show) }
    }
    
    private func showUIElements(_ show: Bool) {
        
        //Show/Hide respected UI Elements
        homeImageView.isHidden = !show
        homeLabel.isHidden = !show
        shareButton.isHidden = !show
        destinationImageView.isHidden = !show
        destinationLabel.isHidden = !show
        paymentTypeTextLabel.isHidden = !show
        paymentTypeLabel.isHidden = !show
        estimateTextLabel.isHidden = !show
        estimatePriceLabel.isHidden = !show
    }
    
    func showShareStatusButton(_ show: Bool) {
        
        shareStatusButton.isHidden = !show
        cancelButton.isHidden = show
        contactButton.isHidden = show
    }
}
