//
//  SearchPlacesView.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 22/05/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

protocol SearchPlacesViewDelegate {
    
    func placeDidSelect(_ place: Place)
}

class SearchPlacesView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var searchPlacesTableView: UITableView!
    
    //MARK: - Variables
    fileprivate weak var vc: UIViewController!
    fileprivate weak var view: UIView!
    var places: [Place]!
    var delegate: SearchPlacesViewDelegate?
    
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
        places = []
        
        //Setup view
        view.backgroundColor = UIColor.clear
        UtilityFunctions().addRoudedBorder(to: overlayView, showCorners: true, borderColor: UIColor.clear, borderWidth: 0, showShadow: true)
        UtilityFunctions().addRoudedBorder(to: searchPlacesTableView, showCorners: true, borderColor: UIColor.clear, borderWidth: 0, showShadow: true)

        //Setup tableView
        searchPlacesTableView.separatorStyle = .none
        
        //Register cell to tableView
        registerCells()
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SearchPlacesView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    //MARK: - Functions
    func registerCells() {
        
        let nib = UINib(nibName: PlaceCell.identifier, bundle: nil)
        searchPlacesTableView.register(nib, forCellReuseIdentifier: PlaceCell.identifier)
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.searchPlacesTableView.reloadData()
        }
    }
}

//MARK: - UITableView Delegate
extension SearchPlacesView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier, for: indexPath) as! PlaceCell
        
        //Setup cell values
        cell.titleLabel.text = places[indexPath.row].title
        cell.subTitleLabel.text = places[indexPath.row].subTitle
        
        //Return cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let place = places[indexPath.row]
        delegate?.placeDidSelect(place)
    }
}
