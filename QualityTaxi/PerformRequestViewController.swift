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
    @IBOutlet weak var startTripTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var startTripWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var startTripHeightConstraint: NSLayoutConstraint!
    
    var blurView = DynamicBlurView()
    var popup = QTPopup()
    var originalStartTripWidth = CGFloat()
    var timerToFadeOut = NSTimer()
    var timerToShowAlert = NSTimer()
    var blurAlertView = DynamicBlurView()
    var alertViewContainer = UIView()
    var startTrip:Bool = false
    
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
        startTrip = !startTrip
        if startTrip {
            originalStartTripWidth = self.startTripWidthConstraint.constant
            UIView.animateWithDuration(0.3, animations: {
                self.cancelTripTopConstraint.constant += 12
                self.arrivalPingLeadingConstraint.constant -= self.arrivalPingLeadingConstraint.constant + self.arrivalPingButton.frame.size.width + 16
                self.cancelTripBottomConstraint.constant -= self.cancelTripBottomConstraint.constant + self.cancelButton.frame.size.height
                self.startTripWidthConstraint.constant = self.directionsContainerView.frame.size.width - self.startTripButton.frame.size.width
                self.startTripHeightConstraint.constant +=  10
                self.startTripButton.setTitle("FINALIZAR VIAJE", forState: .Normal)
                self.view.layoutIfNeeded()
            }) { (complete) in
                self.arrivalPingButton.hidden = true
                //                let alert = QTAlertView.init(frame: UIScreen.mainScreen().bounds)
                //                self.view.addSubview(alert)
                self.timerToShowAlert = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.showAlert(_:)), userInfo: "start", repeats: false)
            }
        }else{
            performSegueWithIdentifier("toFinalizeTrip", sender: self)
        }
        
    }
    
    func showAlert(timer:NSTimer){
        let kind = timer.userInfo as? String
        let titleText:String?
        let imageIcon:UIImage?
        if kind == "start" {
            titleText = "VIAJE INICIADO"
            imageIcon = UIImage(named: "check_ok")
        }else{
            titleText = "AVISO ENVIADO"
            imageIcon = UIImage(named: "bell")
        }
        timerToShowAlert.invalidate()
        let alertWidth:CGFloat = 150
        let alertHeight:CGFloat = 150
        let alertX:CGFloat = ((self.view.frame.size.width - alertWidth)/2)
        let alertY:CGFloat = (self.view.frame.size.height - alertHeight)/2 - 100
        
        blurAlertView = DynamicBlurView(frame: CGRect(x: alertX, y: alertY - 20, width: alertWidth, height: alertHeight))
//        blurAlertView.blendColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        self.blurAlertView.blurRadius = 12
        self.blurAlertView.alpha = 0
        blurAlertView.blendColor = UIColor(hexString: "B7B7B7", withAlpha: 0.15)
        blurAlertView.layer.borderColor = UIColor(hexString: "B7B7B7").CGColor
        self.view.addSubview(blurAlertView)
        
        alertViewContainer = UIView(frame: CGRect(x: alertX, y: alertY - 20, width: alertWidth, height: alertHeight))
        alertViewContainer.alpha = 0
        self.view.addSubview(alertViewContainer)
        
        let imageWidth:CGFloat = 50
        let imageHeight:CGFloat = imageWidth
        let imageX:CGFloat = (alertViewContainer.frame.size.width - imageWidth)/2
        let imageY:CGFloat = (alertViewContainer.frame.size.height - imageHeight)/2 + 10
        
        let checkImageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight))
        checkImageView.image = imageIcon
        alertViewContainer.addSubview(checkImageView)
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: checkImageView.frame.origin.y - 40, width: alertViewContainer.frame.size.width - 20, height: 30))
        titleLabel.text = titleText!
        titleLabel.textColor = UIColor(hexString: "1C3F58")
        titleLabel.font = UIFont(name: "Myriadpro-Semibold", size: 16.0)
        titleLabel.textAlignment = NSTextAlignment.Center
        alertViewContainer.addSubview(titleLabel)
        
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.blurAlertView.alpha = 1
            self.blurAlertView.blurRadius = 12
            self.alertViewContainer.alpha = 1
            self.alertViewContainer.frame = CGRect(x: alertX, y: alertY, width: alertWidth, height: alertHeight)
            self.blurAlertView.frame = CGRect(x: alertX, y: alertY, width: alertWidth, height: alertHeight)
            self.blurAlertView.layer.cornerRadius = 10
            self.blurAlertView.refresh()
            titleLabel.frame = CGRect(x: 10, y: 20, width: self.alertViewContainer.frame.size.width - 20, height: 30)
            }) { (complete) in }
        
        self.timerToFadeOut = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(hideAlert), userInfo: nil, repeats: false)
        
    }
    
    func hideAlert(){
        UIView.animateWithDuration(0.4, animations: {
            self.blurAlertView.alpha = 0
            self.alertViewContainer.alpha = 0
            }) { (complete) in
                self.blurAlertView.removeFromSuperview()
                self.alertViewContainer.removeFromSuperview()
        }
        timerToFadeOut.invalidate()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFinalizeTrip" {
            print("to finalize trip")
        }
    }
    
    @IBAction func arrivalPingButtonPressed(sender: AnyObject) {
        self.timerToShowAlert = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: #selector(self.showAlert(_:)), userInfo: "ping", repeats: false)
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
