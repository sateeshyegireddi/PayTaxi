//
//  SelectDropPoint.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 24/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import GooglePlaces

protocol SelectLocationDelegate {
    
    func placeDidSelect(_ place: Place, isPickup: Bool)
}

class SelectLocation: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationTableView: UITableView!
    
    //MARK: - Variables
    var isPickup: Bool! = false
    var favouritePlaces: [Place]!
    var places: [Place]!
    var fetcher: GMSAutocompleteFetcher?
    var delegate: SelectLocationDelegate?
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        //Init
        places = []
        favouritePlaces = []

        //Setup view
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @objc func locationTextFieldDidChange(_ textField: UITextField) {
        
    }
    
    //MARK: - Functions
    private func initiateAutoCompleteFetcher() {
        
        // Set bounds to inner-west Sydney Australia.
//        let neBoundsCorner = CLLocationCoordinate2D(latitude: -33.843366,
//                                                    longitude: 151.134002)
//        let swBoundsCorner = CLLocationCoordinate2D(latitude: -33.875725,
//                                                    longitude: 151.200349)
//        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
//                                         coordinate: swBoundsCorner)
        
        // Set up the autocomplete filter
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "IN"
        
        // Create the fetcher
        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        fetcher?.delegate = self
    }
    
    func setupView() {
        
        //Add TopView
        let topView = TopView(frame: GlobalConstants.Constants.topViewFrame, on: self,
                              title: "enter_drop_location".localized, enableBack: true, showNotifications: true)
        view.addSubview(topView)

        //Setup TableView
        locationTableView.separatorStyle = .none
        
        //Setup View
        UtilityFunctions().addRoudedBorder(to: locationView, showCorners: true,
                                           borderColor: UIColor.clear, borderWidth: 0, showShadow: true)
        
        //Setup ImageView
        locationImageView.image = isPickup ? #imageLiteral(resourceName: "icon-pickup-location") : #imageLiteral(resourceName: "icon-destination-location")
            
        //Setup TextField
        locationTextField.attributedPlaceholder =
            NSAttributedString(string: "search_locality".localized,
                               attributes: [NSAttributedStringKey.foregroundColor: GlobalConstants.Colors.mercury])
        locationTextField.textColor = GlobalConstants.Colors.tungesten
        locationTextField.font = GlobalConstants.Fonts.verySmallText!
        locationTextField.addTarget(self, action: #selector(locationTextFieldDidChange(_:)), for: .editingChanged)
    }
}


//MARK: - UITableView Delegate
extension SelectLocation: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRows = section == 0 ? places.count : favouritePlaces.count
        return numberOfRows
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
        cell.iconImageView.image = nil
        if indexPath.section == 0 {
            cell.iconImageView.image = #imageLiteral(resourceName: "icon-heart")
        }
        
        //Return cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let place = places[indexPath.row]
        delegate?.placeDidSelect(place, isPickup: isPickup)
    }
}

//MARK: - GMSAutocompleteFetcher Delegate -
extension SelectLocation: GMSAutocompleteFetcherDelegate {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        //Remove all places first
        places.removeAll()
        
        //Add new place from autoCompletePrediction
        for prediction in predictions {
            let place = Place(id: prediction.placeID ?? "", title: prediction.attributedPrimaryText.string,
                              subTitle: prediction.attributedFullText.string)
            places.append(place)
            print("\n",prediction.attributedFullText.string)
            print("\n",prediction.attributedPrimaryText.string)
            print("\n********")
        }
        
        //Reload data
        locationTableView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
        print(error.localizedDescription)
    }
}
