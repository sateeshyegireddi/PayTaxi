//
//  CabCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 22/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class CabCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cabImageView: UIImageView!
    @IBOutlet weak var cabTypeLabel: UILabel!
    
    //MARK: - Variables
    public static let identifier = "CabCell"
    
    //MARK: - Cell Fuctions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        //Setup label
        UtilityFunctions().setStyleForLabel(priceLabel, text: "", textColor: GlobalConstants.Colors.megnisium,
                                            font: GlobalConstants.Fonts.textFieldMediumText!)
        UtilityFunctions().setStyleForLabel(cabTypeLabel, text: "", textColor: GlobalConstants.Colors.megnisium,
                                            font: GlobalConstants.Fonts.textFieldBoldText!)
    }
    
    func setPrice(_ price: String, cabType type: String, cabImage image: UIImage) {
        
        priceLabel.text = price
        cabTypeLabel.text = type
        cabImageView.image = image
    }
    
    func highlightView(_ highlight: Bool) {
        
//        titleLabel.backgroundColor = highlight ? GlobalConstants.Colors.aqua : GlobalConstants.Colors.silver
//        priceLabel.textColor = highlight ? GlobalConstants.Colors.aqua : GlobalConstants.Colors.silver
//        imageView.image = highlight ? #imageLiteral(resourceName: "icon-select-cab") : #imageLiteral(resourceName: "icon-deselct-cab")
    }
}
