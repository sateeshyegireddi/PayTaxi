//
//  NoConnectionView.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 06/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class NoConnectionView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var noInternetLabel: UILabel!
    
    //MARK: - Variables
    fileprivate weak var vc: UIViewController!
    fileprivate weak var view: UIView!
    
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
        
        //Setup label
        view.backgroundColor = UIColor.red
        noInternetLabel.text = GlobalConstants.Errors.internetConnection
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NoConnectionView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
