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
    @IBOutlet weak var seperatorLabel: UILabel!
    
    //MARK: - Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Setup view
        //backgroundColor = UIColor.black
        //contentView.backgroundColor = UIColor.black
        
        //Setup Label
        //menuTitleLabel.textColor = UIColor.white
        seperatorLabel.backgroundColor = UIColor.darkGray

        //Setup ImageView
    }
}
