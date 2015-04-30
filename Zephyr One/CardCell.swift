//
//  CardCell.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/9/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit

class CardCell: PFTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var trackImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        cardSetup()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func cardSetup() {
        cardView.alpha = 1
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 2
//        cardView.layer.shadowOffset = CGSize(width: -0.4, height: 0.4)
//        cardView.layer.shadowRadius = 1
        
        let path = UIBezierPath(rect: cardView.bounds)
//        cardView.layer.shadowPath = path.CGPath
//        cardView.layer.shadowOpacity = 0.2
    }
}
