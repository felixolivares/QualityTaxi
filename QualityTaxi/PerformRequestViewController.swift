//
//  PerformRequestViewController.swift
//  QualityTaxi
//
//  Created by Developer on 8/22/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class PerformRequestViewController: UIViewController, QTPopupDelegate {

    @IBOutlet weak var startTripButton: UIButton!
    @IBOutlet weak var arrivalPingButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var directionsContainerView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var cancelTripBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelTripTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrivalPingLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelTripTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrivalPingBottomConstraint: NSLayoutConstraint!
    
    var blurView = DynamicBlurView()
    var popup = QTPopup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.setHidesBackButton(true, animated: false)
        
        directionsContainerView.layer.borderWidth = 1
        directionsContainerView.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
        
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.addPopup()
    }

    func addPopup(){
        blurView = DynamicBlurView(frame: UIScreen.mainScreen().bounds)
        self.view.addSubview(blurView)
        UIView.animateWithDuration(0.3, animations: { 
            self.blurView.blurRadius = 12
            }) { (completed) in
                self.popup = QTPopup.init(frame: UIScreen.mainScreen().bounds)
                self.popup.delegate = self
                self.view.addSubview(self.popup)
        }
    }
    
    func cancelAction() {
        UIView.animateWithDuration(0.3, animations: {
            self.blurView.blurRadius = 0
        }) { (completed) in
            self.blurView.removeFromSuperview()
            self.popup.removeFromSuperview()
        }
    }
    
    func acceptAction() {
        UIView.animateWithDuration(0.3, animations: {
            self.blurView.blurRadius = 0
        }) { (completed) in
            self.blurView.removeFromSuperview()
            self.popup.removeFromSuperview()
        }
    }
    
    @IBAction func startTripButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.5) {
            self.cancelTripTopConstraint.constant += self.cancelTripBottomConstraint.constant + self.cancelButton.frame.size.height
            self.arrivalPingBottomConstraint.constant += self.cancelTripBottomConstraint.constant + self.cancelButton.frame.size.height
            self.arrivalPingLeadingConstraint.constant -= self.arrivalPingLeadingConstraint.constant + self.arrivalPingButton.frame.size.width + 20
            self.cancelTripBottomConstraint.constant -= self.cancelTripBottomConstraint.constant + self.cancelButton.frame.size.height
            self.view.layoutIfNeeded()
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
