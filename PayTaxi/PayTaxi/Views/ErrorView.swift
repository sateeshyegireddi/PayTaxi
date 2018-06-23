//
//  ErrorView.swift
//  PayTaxi
//
//  Created by Sateesh Yegireddi on 06/06/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: - Variables
    fileprivate weak var vc: UIViewController!
    fileprivate weak var view: UIView!
    var title: String?
    var image: UIImage?
    
    //MARK: - Initialisation
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, inView vc: UIViewController, title text: String?, image pic: UIImage?) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.vc = vc
        self.title = text
        self.image = pic
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }
    
    //MARK: - View
    private func xibSetup(frame: CGRect) {
        
        view = loadViewFromNib()
        
        //Adjust the view size for iPhone 6 and iPhone 6 plus
        view.frame = frame
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ErrorView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func setupUI() {
        
        //Setup view
        view.backgroundColor = GlobalConstants.Colors.maraschino
        
        //Setup label
        titleLabel.text = title
        
        //Setup imageView
        imageView.image = image
    }
    
    //MARK: - Actions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}
