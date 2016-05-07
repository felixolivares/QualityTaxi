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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userLabel.text = tripSelected.name
        rateLabel.text = "$" + tripSelected.rate
        paymentTypeLabel.text = "Efectivo"
        distanceToDestiny.text = String(tripSelected.distance) + " Km."
        distanceToUser.text = String(tripSelected.distanceToUser) + " Km."
        toLabel.text = tripSelected.to
        fromLabel.text = tripSelected.from
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
