//
//  RideComplete.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 04/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class RideComplete: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var dotsImageView: UIImageView!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var driverInfoView: UIView!
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var paymentDoneLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rideCompleteLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var driverOverlayImageView: UIImageView!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet var starButtons: [UIButton]!
    
    //MARK: - Variables
    private var price: String!
    private var rating: Int!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Init Variables
        price = "200.Rs"
        rating = -1
        
        //Setup View
        setupView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func starButtonTapped(_ sender: UIButton) {
        
        //Reset button
        setupButtons()
        
        //Get the index of star button
        if let index = starButtons.index(of: sender) {
            
            //Copy the index to rating object
            rating = index
        }
        
        //Highlight buttons on & before the selected index
        for i in 0...rating {
            
            let button = starButtons[i]
            button.isSelected = true
        }
    }
    
    //MARK: - Functions
    private func setupView() {
        
        //Setup View
        view.backgroundColor = GlobalConstants.Colors.blue
        priceView.accessibilityIdentifier = "PAYMENT"
        driverInfoView.accessibilityIdentifier = "PAYMENT"
        UtilityFunctions().addRoudedBorder(to: priceView, borderColor: UIColor.clear, borderWidth: 0)
        UtilityFunctions().addRoudedBorder(to: driverInfoView, borderColor: UIColor.clear, borderWidth: 0)

        //Setup ImageView
        overlayImageView.image = #imageLiteral(resourceName: "payment-background")
        dotsImageView.image = #imageLiteral(resourceName: "icon-dots-sequence")
        checkboxImageView.image = #imageLiteral(resourceName: "icon-check-box")
        UtilityFunctions().addRoudness(to: driverOverlayImageView,
                                       borderColor: GlobalConstants.Colors.iron.withAlphaComponent(0.4))
        driverOverlayImageView.backgroundColor = UIColor.green
        UtilityFunctions().addRoudness(to: driverImageView,
                                       borderColor: GlobalConstants.Colors.iron.withAlphaComponent(0.4))
        
        //Setup Label
        UtilityFunctions().setStyleForLabel(paymentDoneLabel,
                                            text: "payment_done".localized,
                                            textColor: GlobalConstants.Colors.iron,
                                            font: GlobalConstants.Fonts.textFieldText!)
        UtilityFunctions().addPriceStyle(for: priceLabel, text: price)
        UtilityFunctions().setStyleForLabel(rideCompleteLabel,
                                            text: "ride_complete".localized,
                                            textColor: GlobalConstants.Colors.tungesten,
                                            font: GlobalConstants.Fonts.semiBigBoldText!)
        UtilityFunctions().setStyleForLabel(rateLabel,
                                            text: "rate_the_ride".localized + "PayTaxi Driver",
                                            textColor: GlobalConstants.Colors.tungesten,
                                            font: GlobalConstants.Fonts.textFieldText!)
        UtilityFunctions().setStyleForLabel(driverNameLabel,
                                            text: "PayTaxi Driver",
                                            textColor: GlobalConstants.Colors.tungesten,
                                            font: GlobalConstants.Fonts.labelText!)
        
        //Setup Button
        setupButtons()
    }
    
    private func setupButtons() {
        
        for button in starButtons {
            button.isSelected = false
            button.setImage(#imageLiteral(resourceName: "icon-star-deselect"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "icon-star"), for: .selected)
        }
    }
}







