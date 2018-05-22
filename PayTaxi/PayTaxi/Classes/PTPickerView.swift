//
//  PTPickerView.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 21/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

protocol PTPickerViewDelegate {
    func pickerViewDidEndEditing()
    func pickerViewDidChangeItem(_ item: String)
    func pickerViewDidSelectItemAtIndex(_ index: Int)
}

class PTPickerView: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var dataPickerView: UIPickerView!
    
    //MARK: - Variables
    var objects: [String]!
    var selectedObject: String?
    var selectedIndex: Int!
    var delegate: PTPickerViewDelegate?
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Init variables
        objects = []
        selectedObject = ""
        selectedIndex = 0
        
        //Setup buttons
        cancelButton.setTitleColor(GlobalConstants.Colors.megnisium, for: .normal)
        chooseButton.backgroundColor = GlobalConstants.Colors.green
        UtilityFunctions().addRoudedBorder(to: chooseButton, borderColor: UIColor.clear, borderWidth: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        selectedObject = ""
        delegate?.pickerViewDidEndEditing()
    }
    
    @IBAction func chooseButtonTapped(_ sender: UIButton) {
        
        delegate?.pickerViewDidSelectItemAtIndex(selectedIndex)
    }
    
    //MARK: - Functions
    class func initPickerView(with objects: [String]) -> PTPickerView {
        
        //Create instance of PTPickerView
        let sGPickerView = PTPickerView(nibName: "PTPickerView", bundle: nil)
        
        //Reload pickerView data
        sGPickerView.objects = objects
        
        //Return instance
        return sGPickerView
    }
    
    func setPickerViewObjects(_ objects: [String], selectedRow: Int) {
        
        //Reload pickerView data
        self.objects = objects
        self.dataPickerView?.reloadAllComponents()
        
        //Set default section at index 0
        if objects.count > selectedRow {
            
            selectedIndex = 0
            selectedObject = objects[selectedRow]
            dataPickerView?.selectRow(selectedRow, inComponent: 0, animated: true)
            delegate?.pickerViewDidChangeItem(selectedObject!)
        }
    }
    
    func setSelectedObjectOnPickerView(_ selectedItem: String) {
        
        var i = 0
        
        //Going through each object
        for object in objects {
            
            //Set pickerView object to selected one
            if selectedItem == object {
                
                dataPickerView.selectRow(i, inComponent: 0, animated: true)
                break
            }
            
            i += 1
        }
    }
}

//MARK: UIPickerView Delegate
extension PTPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return objects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedIndex = row
        selectedObject = objects[row]
        delegate?.pickerViewDidChangeItem(selectedObject!)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: objects[row], attributes: [NSAttributedStringKey.foregroundColor : GlobalConstants.Colors.blue])
    }
}
