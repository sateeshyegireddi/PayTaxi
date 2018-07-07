//
//  RideHistoryDetails.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 07/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class RideHistoryDetails: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var rideDetailsTableView: UITableView!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var sendInvoiceButton: UIButton!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View
        setupView()
        
        // Register Cells
        registerCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func supportButtonTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func sendInvoiceButtonTapped(_ sender: UIButton) {
        
        
    }
    
    //MARK: - Functions
    private func registerCells() {
        
        let nib = UINib(nibName: RideLocationsCell.identifier, bundle: nil)
        rideDetailsTableView.register(nib, forCellReuseIdentifier: RideLocationsCell.identifier)
        let nib2 = UINib(nibName: TwoLabelsCell.identifier, bundle: nil)
        rideDetailsTableView.register(nib2, forCellReuseIdentifier: TwoLabelsCell.identifier)
        let nib3 = UINib(nibName: RideMapCell.identifier, bundle: nil)
        rideDetailsTableView.register(nib3, forCellReuseIdentifier: RideMapCell.identifier)
    }

    private func setupView() {
        
        //Add TopView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self,
                              title: "ride_history".localized, enableBack: true, showNotifications: true)
        view.addSubview(topView)

        //Setup View
        overlayView.accessibilityIdentifier = "RideHistoryView"
        UtilityFunctions().addRoudedBorder(to: overlayView, showCorners: true, borderColor: UIColor.clear,
                                           borderWidth: 0, showShadow: true, shadowColor: GlobalConstants.Colors.mercury)

        //Setup ImageView
        overlayImageView.image = #imageLiteral(resourceName: "dots-background")
        
        //Setup Buttons
        buttonHeight.constant = UIScreen.main.bounds.height == 320 ? 45 : 50
        UtilityFunctions().setStyle(for: supportButton, text: "support".localized,
                                    backgroundColor: GlobalConstants.Colors.green)
        UtilityFunctions().setStyle(for: sendInvoiceButton, text: "send_invoice".localized,
                                    backgroundColor: GlobalConstants.Colors.green)
    }
}

//MARK: - UITableView Delegate -
extension RideHistoryDetails: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 2, 4:
            return 17
        case 3:
            return 7
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            return 2
        case 2:
            return 5
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: RideLocationsCell.identifier,
                                                     for: indexPath) as! RideLocationsCell
            
            //Setup cell values
            cell.carNameLabel.text = "Sedan-Honda City"
            cell.carImageView.image = #imageLiteral(resourceName: "icon-cab-mini-select")
            cell.sourceLabel.text = "Source Location"
            cell.destinationLabel.text = "Destination Location"
            
            //Return cell
            return cell
            
        case 1:
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: TwoLabelsCell.identifier,
                                                     for: indexPath) as! TwoLabelsCell
            
            //Setup cell values
            cell.setLightTextMode(indexPath.row == 0)
            cell.leftLabel.text = indexPath.row == 0 ? "start_time".localized : "06 July 2018 - 17:30"
            cell.rightLabel.text = indexPath.row == 0 ? "end_time".localized : "06 July 2018 - 18:30"

            //Return cell
            return cell
          
        case 2:
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: TwoLabelsCell.identifier,
                                                     for: indexPath) as! TwoLabelsCell
            
            //Setup cell values
            cell.setLightTextMode(indexPath.row == 0)
            
            switch indexPath.row {
            case 0:
                cell.leftLabel.text = "bill_details".localized
            case 1:
                cell.leftLabel.text = "ride_fare".localized
                cell.rightLabel.text = "Rs 100.00"
            case 2:
                cell.leftLabel.text = "taxes_fees".localized
                cell.rightLabel.text = "Rs 10.10"
            case 3:
                cell.leftLabel.text = "promo".localized + "PAY10"
                cell.rightLabel.text = "- Rs 10.00"
            case 4:
                cell.leftLabel.text = "roundoff".localized
                cell.rightLabel.text = "Rs 00.90"
            default:
                break
            }
            
            //Return cell
            return cell
            
        case 3:
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: TwoLabelsCell.identifier,
                                                     for: indexPath) as! TwoLabelsCell
            
            //Setup cell values
            cell.leftLabel.font = GlobalConstants.Fonts.verySmallBoldText!
            cell.leftLabel.textColor = GlobalConstants.Colors.orange
            cell.rightLabel.font = GlobalConstants.Fonts.verySmallMediumText!
            cell.rightLabel.textColor = GlobalConstants.Colors.orange
            cell.leftLabel.text = "total".localized
            cell.rightLabel.text = "Rs 120.00"
            
            //Return cell
            return cell
            
        case 4:
            //Create cell
            let cell = tableView.dequeueReusableCell(withIdentifier: RideMapCell.identifier,
                                                     for: indexPath) as! RideMapCell
            
            //Setup cell values
            cell.driverNameLabel.text = "DRIVER NAME"
            cell.carNumberLabel.text = "AP 09 PT 9999"
            cell.setRating(3)
            
            //Return cell
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
