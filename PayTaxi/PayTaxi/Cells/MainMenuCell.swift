//
//  MainMenuCell.swift
//  PayTaxi
//
//  Created by Sateesh on 5/9/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class MainMenuCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    
    //MARK: - Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Setup view
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        //Setup Label
        menuTitleLabel.textColor = GlobalConstants.Colors.megnisium
        menuTitleLabel.font = GlobalConstants.Fonts.textFieldText!
    }
}
