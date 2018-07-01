//
//  OfferCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 30/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class OfferCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Variables
    public static let identifier = "OfferCell"

    //MARK: - Cell Fuctions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup View
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        overlayView.accessibilityIdentifier = "OffersView"
        UtilityFunctions().addRoudedBorder(to: overlayView, showCorners: true, borderColor: GlobalConstants.Colors.silver,
                                           borderWidth: 0.5, showShadow: true)
        //Setup ImageView
        offerImageView.image = #imageLiteral(resourceName: "icon-offer")
        
        // Setup Label
        UtilityFunctions().setStyleForLabel(titleLabel, text: "", textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.textFieldBoldText!)
        UtilityFunctions().setStyleForLabel(descriptionLabel, text: "", textColor: GlobalConstants.Colors.tungesten,
                                            font: GlobalConstants.Fonts.tinyText!)
    }
    
    func setTitle(_ title: String, description details: String, highlight glow: Bool) {
        
        titleLabel.text = title
        descriptionLabel.text = details
        offerImageView.image = glow ? #imageLiteral(resourceName: "icon-offer-select") : #imageLiteral(resourceName: "icon-offer")
        titleLabel.textColor = glow ? UIColor.white : GlobalConstants.Colors.blue
        descriptionLabel.textColor = glow ? UIColor.white : GlobalConstants.Colors.tungesten
        overlayView.backgroundColor = glow ? GlobalConstants.Colors.aqua : UIColor.white

        if glow {
            UtilityFunctions().addRoudedBorder(to: overlayView, showCorners: true, borderColor: GlobalConstants.Colors.oceanblue,
                                               borderWidth: 1, showShadow: true, shadowColor: GlobalConstants.Colors.aqua)
        } else {
            UtilityFunctions().addRoudedBorder(to: overlayView, showCorners: true, borderColor: GlobalConstants.Colors.silver,
                                               borderWidth: 1, showShadow: true, shadowColor: GlobalConstants.Colors.silver)
        }
    }
}
