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
    @IBOutlet var menuTitleLabel: UILabel!
    @IBOutlet var menuImageView: UIImageView!
    
    //MARK: - Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Setup view
        backgroundColor = UIColor.black
        contentView.backgroundColor = UIColor.black
        
        //Setup Label
        menuTitleLabel.textColor = UIColor.white
        
        //Setup ImageView
//        menuImageView.layer.borderColor = GlobalConstants.Colors.tangerine.cgColor
//        menuImageView.layer.borderWidth = 2
        menuImageView.layer.cornerRadius = menuImageView.bounds.height/2
        menuImageView.layer.masksToBounds = true
    }
    
    func setTitle(_ title: String?) {
        
        menuTitleLabel.text = title
    }
}
