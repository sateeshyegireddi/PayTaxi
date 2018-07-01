//
//  Payments.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 30/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class Payments: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var estimatedPriceLabel: UILabel!
    @IBOutlet weak var priceTextLabel: UILabel!
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var payTextLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var confirmRideButton: UIButton!
    @IBOutlet var priceLabelSpacings: [NSLayoutConstraint]!
    @IBOutlet var discountPriceLabelSpacings: [NSLayoutConstraint]!
    @IBOutlet weak var discountPriceTop: NSLayoutConstraint!
    @IBOutlet weak var discountedPriceHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var price: String!
    var discountedPrice: String!
    var selectedIndex: Int!
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init Variables
        price = "200.Rs"
        discountedPrice = "190.Rs"
        selectedIndex = -1
        
        // Setup View
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Actions
    @IBAction func confirmRideButtonTapped(_ sender: UIButton) {
    
        
    }
    
    //MARK: - Functions
    
    private func showDiscountPrice(_ show: Bool) {
        
        discountedPriceHeight.constant = show ? 70 : 0
        payTextLabel.isHidden = !show
        let topSpace: CGFloat = UIScreen.main.bounds.width == 320 ? 15 : 20
        discountPriceTop.constant = show ? topSpace : 0

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    private func registerCells() {
        
        let nib = UINib(nibName: OfferCell.identifier, bundle: nil)
        offersTableView.register(nib, forCellReuseIdentifier: OfferCell.identifier)
    }
    
    private func setupView() {
        
        //Add TopView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self,
                              title: "payment_method".localized, enableBack: true, showNotifications: true)
        view.addSubview(topView)

        //Setup View
        for space in priceLabelSpacings {
            space.constant = UIScreen.main.bounds.width == 320 ? 25 : 30
        }
        
        for space in discountPriceLabelSpacings {
            space.constant = UIScreen.main.bounds.width == 320 ? 15 : 20
        }
        
        //Setup Label
        UtilityFunctions().addPriceStyle(for: estimatedPriceLabel, text: price)
        UtilityFunctions().setStyleForLabel(priceTextLabel,
                                            text: "estimated_fare_message".localized,
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().addPriceStyle(for: discountPriceLabel, text: discountedPrice)
        UtilityFunctions().setStyleForLabel(payTextLabel,
                                            text: "payment_confirm_message".localized,
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.smallBoldText!)
        
        //Setup button
        UtilityFunctions().setStyle(for: confirmRideButton, text: "confirm_ride".localized,
                                    backgroundColor: GlobalConstants.Colors.green)
        
        //Register Cells to TableView
        registerCells()
        
        //Hide discounted price initially
        showDiscountPrice(false)
    }
}

extension Payments: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create cell
        let offerCell = tableView.dequeueReusableCell(withIdentifier: OfferCell.identifier, for: indexPath) as! OfferCell
        
        //Setup cell values
        offerCell.setTitle("RIDE NOW. PAY LATER.", description: "Pay ride bills of 15 days up to Rs.1000 - all at once!",
                           highlight: selectedIndex == indexPath.row)
        
        //Return cell
        return offerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If the offer is already selected, remove it from being selected again
        selectedIndex = selectedIndex != indexPath.row ? indexPath.row : -1
        showDiscountPrice(selectedIndex == indexPath.row)
        UtilityFunctions().addPriceStyle(for: discountPriceLabel, text: discountedPrice)
        tableView.reloadData()
    }
}











