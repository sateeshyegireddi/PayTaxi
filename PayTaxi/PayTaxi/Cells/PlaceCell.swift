//
//  PlaceCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 22/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    //MARK: - Variables
    public static let identifier = "PlaceCell"
    
    //MARK: - Cell Fuctions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        //Setup label
        titleLabel.textColor = GlobalConstants.Colors.tungesten
        subTitleLabel.textColor = GlobalConstants.Colors.tungesten
    }
}
