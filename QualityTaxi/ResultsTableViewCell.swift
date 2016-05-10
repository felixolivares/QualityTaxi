//
//  ResultsTableViewCell.swift
//  QualityTaxi
//
//  Created by Developer on 5/2/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
