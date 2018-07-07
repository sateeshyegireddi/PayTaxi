//
//  RideHistory.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 07/07/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class RideHistory: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var rideHistoryTableView: UITableView!
    
    //MARK: - Variables
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup View
        setupView()
        
        //Register TableViewCell
        registerCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions
    private func registerCells() {
        
        let nib = UINib(nibName: RideHistoryCell.identifier, bundle: nil)
        rideHistoryTableView.register(nib, forCellReuseIdentifier: RideHistoryCell.identifier)
    }
    
    private func setupView() {
        
        //Add TopView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self,
                              title: "ride_history".localized, enableBack: false, showNotifications: true)
        view.addSubview(topView)
    }
}

extension RideHistory: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: RideHistoryCell.identifier, for: indexPath) as! RideHistoryCell
        
        //Setup cell values
        cell.carTypeLabel.text = "Pay100AC"
        cell.carNameLabel.text = "Sedan-Honda City"
        cell.sourceLabel.text = "Source Location"
        cell.destinationLabel.text = "Destination Location"
        cell.journeyDateLabel.text = "06 July 2018 - 18:30"
        cell.fareLabel.text = "100 Rs"
        cell.setRating(3)
        
        //Return cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
