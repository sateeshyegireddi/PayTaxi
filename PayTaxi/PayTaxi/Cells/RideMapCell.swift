//
//  RideMapCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 07/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class RideMapCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var carNumberTitleLabel: UILabel!
    @IBOutlet weak var carNumberLabel: UILabel!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var driverRatingLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet weak var mapImageView: UIImageView!
    
    //MARK: - Variables
    public static let identifier = "RideMapCell"

    //MARK: - Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear

        //Setup ImageView
        UtilityFunctions().addRoudness(to: overlayImageView,
                                       borderColor: GlobalConstants.Colors.iron.withAlphaComponent(0.4))
        overlayImageView.backgroundColor = UIColor.green
        UtilityFunctions().addRoudness(to: driverImageView,
                                       borderColor: GlobalConstants.Colors.iron.withAlphaComponent(0.4))

        //Setup Label
        UtilityFunctions().setStyleForLabel(driverNameLabel, text: "", textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.textFieldBoldText!)
        UtilityFunctions().setStyleForLabel(carNumberTitleLabel, text: "car_number".localized,
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.tooSmallMediumText!)
        UtilityFunctions().setStyleForLabel(carNumberLabel, text: "", textColor: GlobalConstants.Colors.blue,
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().setStyleForLabel(driverRatingLabel, text: "rating".localized,
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.tooSmallMediumText!)
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
