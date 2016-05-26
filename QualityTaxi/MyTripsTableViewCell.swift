//
//  MyTripsTableViewCell.swift
//  QualityTaxi
//
//  Created by Developer on 5/19/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class MyTripsTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tripImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderColor = UIColor(hexString: "D3D5D5").CGColor
        containerView.layer.borderWidth = 1.0
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
