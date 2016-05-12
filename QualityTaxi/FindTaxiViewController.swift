//
//  FindTaxiViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/29/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit
import FontAwesome_swift


class FindTaxiViewController: UIViewController, UIGestureRecognizerDelegate {

    var taskTimer: NSTimer!
    let defaults = NSUserDefaults.standardUserDefaults()
    var moneyLeft = Float()
    var isMapTabActive:Bool = false
    
    @IBOutlet weak var firstTab: UIView!
    @IBOutlet weak var mapIconHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapIconLabel: UILabel!
    
    @IBOutlet weak var mapIconLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taxiImage: UIImageView!
    @IBOutlet weak var driverDetailsContainer: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var goToStartBtn: UIButton!
    @IBOutlet weak var moneyLeftLabel: UILabel!
    @IBOutlet weak var mapIcon: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
        
//        segmentedControl.alpha = 0
        viewMap.alpha = 0
        viewMap.layer.cornerRadius = 5
        goToStartBtn.layer.cornerRadius = 5
        goToStartBtn.alpha = 0
        infoContainerView.alpha = 0
        
        driverDetailsContainer.layer.cornerRadius = 5
        driverDetailsContainer.layer.borderColor = UIColor(hexString: "BABDBE").CGColor
        driverDetailsContainer.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        EZLoadingActivity.show("Solicitando Taxi", disableUI: false)
        
        taskTimer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(FindTaxiViewController.runTimedCode), userInfo: nil, repeats: true)
        
        moneyLeftLabel.text = String(format: "$%.2f", defaults.floatForKey("moneyLeft"))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(activeMapTab))
        tap.delegate = self
        firstTab.addGestureRecognizer(tap)
        
        mapIcon.font = UIFont.fontAwesomeOfSize(14)
        mapIcon.text = String.fontAwesomeIconWithCode("fa-map-marker")
        mapIcon.textColor = UIColor(hexString: "F7F7F7")
        
        
        
    }
    
    func activeMapTab(){
        if isMapTabActive {
            //Fade out
            mapIconHorizontalConstraint.constant += 4
            mapIconLabelBottomConstraint.constant -= 11
            UIView.animateWithDuration(0.1) {
                self.view.layoutIfNeeded()
                self.mapIconLabel.alpha = 0
                self.mapIcon.textColor = UIColor(hexString: "7F7F7F")
            }
        }else{
            //Fade in
            mapIconHorizontalConstraint.constant -= 4
            mapIconLabelBottomConstraint.constant += 11
            UIView.animateWithDuration(0.1) {
                self.mapIconLabel.alpha = 1
                self.mapIcon.textColor = UIColor(hexString: "F7F7F7")
                self.view.layoutIfNeeded()
            }
        }
        isMapTabActive = !isMapTabActive
    }

    func runTimedCode(){
        EZLoadingActivity.hide()
        taskTimer.invalidate()
        
        UIView.animateWithDuration(0.3) {
//            self.segmentedControl.alpha = 1
            self.infoContainerView.alpha = 1
            self.goToStartBtn.alpha = 1
            self.titleLabel.text = "Hemos asignado un taxi para ti y ahora mismo va en camino!"
            self.view.layoutIfNeeded()
        }
        defaults.setBool(true, forKey: "onGoingTrip")
        self.showNewBalance()
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToStartPressed(sender: AnyObject) {
        performSegueWithIdentifier("unwindToStart", sender: self)
    }
    
    func showNewBalance(){
        moneyLeft = defaults.floatForKey("moneyLeft")
        moneyLeft = moneyLeft - 35.00
        defaults.setFloat(moneyLeft, forKey: "moneyLeft")
        defaults.synchronize()
        UIView.animateWithDuration(0.4, animations: {
            self.moneyLeftLabel.alpha = 0
            self.balanceTitleLabel.alpha = 0
            }) { (complete) in
                UIView.animateWithDuration(0.4, animations: {
                    self.moneyLeftLabel.text = String(format: "$%.2f", self.moneyLeft)
                    self.balanceTitleLabel.text = "Saldo Actualizado:"
                    self.moneyLeftLabel.alpha = 1
                    self.balanceTitleLabel.alpha = 1
                })
        }
    }
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("info")
            UIView.animateWithDuration(0.3, animations: {
                self.viewMap.alpha = 0
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.2, animations: {
                        self.infoContainerView.alpha = 1
                    })
            })
        case 1:
            print("map")
            UIView.animateWithDuration(0.3, animations: {
                self.infoContainerView.alpha = 0
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.2, animations: {
                        self.viewMap.alpha = 1
                    })
            })
        default:
            print("default")
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
