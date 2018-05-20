//
//  EditTextFieldCell.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 20/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class EditTextFieldCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var textField: PTTextField!
    
    //MARK: - Variables
    public static let identifier = "EditTextFieldCell"
    
    //MARK: - Cell Fuctions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
    }
}
