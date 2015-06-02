//
//  CardCell.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/9/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit
import MapKit

class CardCell: PFTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            driveManager.mapView = mapView
        }
    }
    
    var driveManager = FlatDriveViewManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardSetup()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func cardSetup() {
        cardView.alpha = 1
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 3
        cardView.layer.borderColor = "#aaa".CGColor
        cardView.layer.borderWidth = 1.0
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 0.8)
//        cardView.layer.shadowRadius = 2
        
//        let path = UIBezierPath(rect: cardView.bounds)
//        cardView.layer.shadowPath = path.CGPath
//        cardView.layer.shadowOpacity = 0.2
    }
}
