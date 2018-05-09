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
    @IBOutlet var hilightImageView: UIImageView!
    @IBOutlet var sectionImageView: UIImageView!
    @IBOutlet var sectionTitleLabel: UILabel!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var sectionButton: UIButton!
    
    //MARK: - Functions
    override func awakeFromNib() {
        
        //Setup View
        backgroundColor = UIColor.black
        
        //Setup Label
        sectionTitleLabel.textColor = UIColor.white
    }
    
    func setupValuesInHeader(WithTitle title: String?, Image image: UIImage?) {
        
        sectionTitleLabel.text = title
        sectionImageView.image = image
    }
    
    func highlightHeaderSection(_ highlight: Bool) {
        
        hilightImageView.backgroundColor = highlight ? GlobalConstants.Colors.orange : UIColor.clear
        UIView.animate(withDuration: 0.5) { 
            self.arrowImageView.image = highlight ? #imageLiteral(resourceName: "icon-down-arrow") : #imageLiteral(resourceName: "icon-right-arrow")
        }
    }
}
