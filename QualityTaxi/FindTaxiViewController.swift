//
//  FindTaxiViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/29/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit


class FindTaxiViewController: UIViewController {

    var taskTimer: NSTimer!
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taxiImage: UIImageView!
    @IBOutlet weak var driverDetailsContainer: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taxiImage.alpha = 0
        driverDetailsContainer.alpha = 0
        driverDetailsContainer.layer.cornerRadius = 10
        driverDetailsContainer.layer.borderColor = UIColor(hexString: "BABDBE").CGColor
        driverDetailsContainer.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        EZLoadingActivity.show("Buscando", disableUI: false)
        
        taskTimer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(FindTaxiViewController.runTimedCode), userInfo: nil, repeats: true)
        
        if self.view.frame.size.height < 500{
            print("small screen")
            imageHeightConstraint.constant = 80.0
            imageWidthConstraint.constant = 80.0
            titleTopConstraint.constant = 5
            imageTopConstraint.constant = 5
        }
        
    }

    func runTimedCode(){
        EZLoadingActivity.hide(success: true, animated: true)
        taskTimer.invalidate()
        
        UIView.animateWithDuration(0.3) { 
            self.taxiImage.alpha = 1
            self.driverDetailsContainer.alpha = 1
            self.titleLabel.text = "Hemos encontrado un taxi para ti y ahora mismo va en camino!"
            self.view.layoutIfNeeded()
        }
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
