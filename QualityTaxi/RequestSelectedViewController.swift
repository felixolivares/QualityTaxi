//
//  RequestSelectedViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/30/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class RequestSelectedViewController: UIViewController {

    var tripSelected = ClientTrip()
    
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var distanceToDestiny: UILabel!
    @IBOutlet weak var distanceToUser: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var rateContainerView: UIView!
    @IBOutlet weak var directionsContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userLabel.text = tripSelected.name
        rateLabel.text = "$" + tripSelected.rate + " MX"
        paymentTypeLabel.text = "Efectivo"
        distanceToDestiny.text = String(tripSelected.distance) + " Km"
        distanceToUser.text = String(tripSelected.distanceToUser) + " Km"
        toLabel.text = tripSelected.to
        fromLabel.text = tripSelected.from
        
        mainContainerView.layer.cornerRadius = 3
        mainContainerView.layer.borderWidth = 1
        mainContainerView.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
        mainContainerView.layer.shadowColor = UIColor(hexString: "717171").CGColor
        mainContainerView.layer.shadowOpacity = 0.5
        mainContainerView.layer.shadowOffset = CGSizeZero
        mainContainerView.layer.shadowRadius = 2
        
        directionsContainerView.layer.borderWidth = 1
        directionsContainerView.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
        
        rateContainerView.layer.borderWidth = 1
        rateContainerView.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
        
        infoContainerView.layer.borderWidth = 1
        infoContainerView.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
