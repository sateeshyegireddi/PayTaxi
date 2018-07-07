//
//  TwoLabelsCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 07/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class TwoLabelsCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    //MARK: - Variables
    public static let identifier = "TwoLabelsCell"

    //MARK: - Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear

        //Setup Label
        leftLabel.text = ""
        rightLabel.text = ""
    }
    
    func setLightTextMode(_ lightMode: Bool) {
        
        let font = lightMode ? GlobalConstants.Fonts.verySmallMediumText : GlobalConstants.Fonts.verySmallText
        let color = lightMode ? GlobalConstants.Colors.tungesten : GlobalConstants.Colors.iron.withAlphaComponent(0.55)
        leftLabel.font = font!
        leftLabel.textColor = color
        rightLabel.font = font!
        rightLabel.textColor = color
    }
}
