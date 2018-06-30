//
//  CabsView.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 22/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class CabsView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var requestRideButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cabsCollectionView: UICollectionView!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var safeAreaView: UIView!
    
    //MARK: - Variables
    fileprivate weak var vc: UIViewController!
    fileprivate weak var view: UIView!
    fileprivate var selectedCabIndex: Int = 0
    var titles: [String]!
    var message: String!
    var arrivalTime: String!
    
    //MARK: - View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, inView vc: UIViewController) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.vc = vc
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }
    
    private func xibSetup(frame: CGRect) {
        
        view = loadViewFromNib()
        
        //Adjust the view size for iPhone 6 and iPhone 6 plus
        view.frame = frame
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CabsView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    //MARK: - Functions
    private func setupView() {
        
        //Init Variables
        titles = ["MINI", "RENAL", "SHARE", "MICRO", "SUV"]
        message = "Sample message here...!"
        arrivalTime = "ETA - --MIN"
        
        //Setup view
        view.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        safeAreaView.backgroundColor = GlobalConstants.Colors.orange
        
        //Setup ImageView
        overlayImageView.image = #imageLiteral(resourceName: "cab-select-background")

        //Setup Label
        UtilityFunctions().setStyleForLabel(messageLabel, text: message,
                                            textColor: GlobalConstants.Colors.megnisium,
                                            font: GlobalConstants.Fonts.smallBoldText!)
        UtilityFunctions().setStyleForLabel(etaLabel, text: arrivalTime,
                                            textColor: UIColor.white,
                                            font: GlobalConstants.Fonts.textFieldBoldText!)
        etaLabel.backgroundColor = GlobalConstants.Colors.orange
        
        //Setup Button
        UtilityFunctions().setStyle(for: requestRideButton, text: "request_ride".localized,
                                    backgroundColor: GlobalConstants.Colors.green)
        
        //Register cell to CollectionView
        registerCells()
    }
    
    private func registerCells() {
        
        let nib = UINib(nibName: CabCell.identifier, bundle: nil)
        cabsCollectionView.register(nib, forCellWithReuseIdentifier: CabCell.identifier)
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.cabsCollectionView.reloadData()
        }
    }
    
    //MARK: - Actions
    @IBAction func confirmPickupButtonTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func tapOnView(_ sender: UITapGestureRecognizer) {
        
        //Hide keyboard if user is tapped out of content view
        if sender.state == .ended { removeFromSuperview() }
    }
    
}

//MARK: - UICollectionView Delegate -
extension CabsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CabCell.identifier, for: indexPath) as! CabCell

        //Setup cell values
        cell.highlightView(selectedCabIndex == indexPath.row)
        
        //Show dummy data
        cell.setPrice("₹\(indexPath.row * 200 + 260)", cabType: titles[indexPath.row], cabImage: #imageLiteral(resourceName: "icon-cab-mini-select"))
        
        //Return cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCabIndex = indexPath.row
        collectionView.reloadData()
    }
}



