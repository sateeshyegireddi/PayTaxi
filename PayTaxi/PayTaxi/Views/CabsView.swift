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
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var cabsCollectionView: UICollectionView!
    @IBOutlet weak var confirmPickupButton: UIButton!
    
    //MARK: - Variables
    fileprivate weak var vc: UIViewController!
    fileprivate weak var view: UIView!
    var selectedCabIndex: Int = 0
    var titles: [String]!
    
    //MARK: - View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, inView vc: UIViewController) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.vc = vc
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
        
        //Init
        titles = ["Mini", "Sedan", "Hatchback", "MPV", "SUV"]
        //Setup view
        view.backgroundColor = UIColor.clear
        UtilityFunctions().addRoudedBorder(to: overlayView, showCorners: true, borderColor: UIColor.clear, borderWidth: 0, showShadow: true)
        confirmPickupButton.backgroundColor = GlobalConstants.Colors.green
        UtilityFunctions().addRoudedBorder(to: confirmPickupButton, showCorners: true, borderColor: UIColor.clear, borderWidth: 0, showShadow: true)
        confirmPickupButton.setTitle("confirm_pickup".localized, for: .normal)
        
        //Register cell to tableView
        registerCells()
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CabsView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    //MARK: - Functions
    func registerCells() {
        
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
}

//MARK: - UICollectionView Delegate -
extension CabsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 95, height: 160)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CabCell.identifier, for: indexPath) as! CabCell

        //Setup cell values
        cell.highlightView(selectedCabIndex == indexPath.row)
        
        //Show dummy data
        cell.priceLabel.text = "₹\(indexPath.row * 200 + 260)"
        cell.titleLabel.text = titles[indexPath.row]
        
        //Return cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCabIndex = indexPath.row
        collectionView.reloadData()
    }
}



