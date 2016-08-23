//
//  PerformRequestViewController.swift
//  QualityTaxi
//
//  Created by Developer on 8/22/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class PerformRequestViewController: UIViewController {

    @IBOutlet weak var startTripButton: UIButton!
    @IBOutlet weak var arrivalPingButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        let blurView = DynamicBlurView(frame: view.bounds)
        view.addSubview(blurView)
        UIView.animateWithDuration(0.3) {
            blurView.blurRadius = 15
        }
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
