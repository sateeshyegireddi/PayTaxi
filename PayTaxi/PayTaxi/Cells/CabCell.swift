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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK: - Variables
    public static let identifier = "CabCell"
    
    //MARK: - Cell Fuctions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        //Setup label
        titleLabel.layer.cornerRadius = 3
        titleLabel.layer.masksToBounds = true
    }
    
    func highlightView(_ highlight: Bool) {
        
        titleLabel.backgroundColor = highlight ? GlobalConstants.Colors.aqua : GlobalConstants.Colors.silver
        priceLabel.textColor = highlight ? GlobalConstants.Colors.aqua : GlobalConstants.Colors.silver
        imageView.image = highlight ? #imageLiteral(resourceName: "icon-select-cab") : #imageLiteral(resourceName: "icon-deselct-cab")
    }
}
