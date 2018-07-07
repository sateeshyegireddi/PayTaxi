//
//  RideHistoryCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 07/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class RideHistoryCell: UITableViewCell {

    //MARK: - Variables
    public static let identifier = "RideHistoryCell"

    //MARK: - Outlets
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var sourceTitleLabel: UILabel!
    @IBOutlet weak var journeyDateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet weak var dotsImageView: UIImageView!
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var destinationTitleLabel: UILabel!
    @IBOutlet weak var fareTitleLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    
    //MARK: - Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Setup View
        overlayView.accessibilityIdentifier = "RideHistoryView"
        UtilityFunctions().addRoudedBorder(to: overlayView, showCorners: true, borderColor: UIColor.clear,
                                           borderWidth: 0, showShadow: true, shadowColor: GlobalConstants.Colors.mercury)
        
        //Setup ImageView
        sourceImageView.image = #imageLiteral(resourceName: "icon-source-black")
        destinationImageView.image = #imageLiteral(resourceName: "icon-destination-blue")
        for imageView in starImageViews {
            imageView.image = #imageLiteral(resourceName: "icon-star-deselect")
        }
        
        //Setup Label
        UtilityFunctions().setStyleForLabel(carTypeLabel, text: "", textColor: GlobalConstants.Colors.orange,
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().setStyleForLabel(carNameLabel, text: "", textColor: GlobalConstants.Colors.orange,
                                            font: GlobalConstants.Fonts.verySmallBoldText!)
        UtilityFunctions().setStyleForLabel(sourceTitleLabel, text: "source_location".localized,
                                            textColor: GlobalConstants.Colors.tungesten,
                                            font: GlobalConstants.Fonts.smallMediumText!)
        UtilityFunctions().setStyleForLabel(journeyDateLabel, text: "", textColor: GlobalConstants.Colors.tungesten,
                                            font: GlobalConstants.Fonts.verySmallMediumText!)
        UtilityFunctions().setStyleForLabel(sourceLabel, text: "", textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.verySmallMediumText!)
        
        UtilityFunctions().setStyleForLabel(destinationTitleLabel, text: "destination".localized,
                                            textColor: GlobalConstants.Colors.tungesten,
                                            font: GlobalConstants.Fonts.smallMediumText!)
        UtilityFunctions().setStyleForLabel(fareTitleLabel, text: "fare".localized, textColor: GlobalConstants.Colors.silver,
                                            font: GlobalConstants.Fonts.verySmallMediumText!)
        UtilityFunctions().setStyleForLabel(destinationLabel, text: "",
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.verySmallMediumText!)
        UtilityFunctions().setStyleForLabel(fareLabel, text: "", textColor: GlobalConstants.Colors.green,
                                            font: GlobalConstants.Fonts.textFieldMediumText!)
    }
    
    func setRating(_ rating: Int) {
        
        //Reset ImageViews
        for imageView in starImageViews {
            
            imageView.image = #imageLiteral(resourceName: "icon-star-deselect")
        }

        //Set star-image to ImageView
        for i in 1...rating {
            
            let imageView = starImageViews[i-1]
            imageView.image = #imageLiteral(resourceName: "icon-star")
        }
    }
}
