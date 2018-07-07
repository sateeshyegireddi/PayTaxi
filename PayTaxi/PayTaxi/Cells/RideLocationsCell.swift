//
//  RideLocationsCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 07/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class RideLocationsCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var sourceTitleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dotsImageView: UIImageView!
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var destinationTitleLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    //MARK: - Variables
    public static let identifier = "RideLocationsCell"

    //MARK: - Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        //Setup ImageView
        sourceImageView.image = #imageLiteral(resourceName: "icon-source-black")
        destinationImageView.image = #imageLiteral(resourceName: "icon-destination-blue")
        
        //Setup Label
        UtilityFunctions().setStyleForLabel(carNameLabel, text: "", textColor: GlobalConstants.Colors.orange,
                                            font: GlobalConstants.Fonts.textFieldBoldText!)
        UtilityFunctions().setStyleForLabel(sourceTitleLabel, text: "source_location".localized,
                                            textColor: GlobalConstants.Colors.tungesten,
                                            font: GlobalConstants.Fonts.smallMediumText!)
        UtilityFunctions().setStyleForLabel(sourceLabel, text: "", textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.verySmallMediumText!)
        
        UtilityFunctions().setStyleForLabel(destinationTitleLabel, text: "destination".localized,
                                            textColor: GlobalConstants.Colors.tungesten,
                                            font: GlobalConstants.Fonts.smallMediumText!)
        UtilityFunctions().setStyleForLabel(destinationLabel, text: "",
                                            textColor: GlobalConstants.Colors.iron.withAlphaComponent(0.55),
                                            font: GlobalConstants.Fonts.verySmallMediumText!)
    }
}
