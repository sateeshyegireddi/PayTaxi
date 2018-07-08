//
//  CancelRideCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 07/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class CancelRideCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var seperatorImageView: UIImageView!
    
    //MARK: - Variables
    public static let identifier = "CancelRideCell"

    //MARK: - Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Setup ImageView
        seperatorImageView.backgroundColor = GlobalConstants.Colors.megnisium
        
        //Setup Button
        cancelButton.titleLabel?.textColor = GlobalConstants.Colors.tungesten
        cancelButton.titleLabel?.font = GlobalConstants.Fonts.smallMediumText!
        cancelButton.setImage(#imageLiteral(resourceName: "icon-checkbox-unselect"), for: .normal)
        cancelButton.setImage(#imageLiteral(resourceName: "icon-checkBox"), for: .selected)
    }
}
