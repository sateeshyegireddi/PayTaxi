//
//  MainMenuHeader.swift
//  PayTaxi
//
//  Created by Sateesh on 5/9/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class MainMenuHeader: UIView {

    //MARK: - IBOutlets
    @IBOutlet var sectionImageView: UIImageView!
    @IBOutlet var sectionTitleLabel: UILabel!
    @IBOutlet var sectionButton: UIButton!
    
    //MARK: - Functions
    override func awakeFromNib() {
        
        //Setup View
        //backgroundColor = UIColor.black
        
        //Setup Label
        //sectionTitleLabel.textColor = UIColor.white
    }
}
