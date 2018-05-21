//
//  TermsConditionsCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 21/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class TermsConditionsCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Variables
    public static let identifier = "TermsConditionsCell"
    
    //MARK: - Cell Fuctions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        //Setup label
        titleLabel.textColor = GlobalConstants.Colors.megnisium
    }
}
