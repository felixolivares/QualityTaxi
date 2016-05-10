//
//  MainViewController.swift
//  QualityTaxi
//
//  Created by Felix Olivares on 11/4/15.
//  Copyright © 2015 Felix Olivares. All rights reserved.
//

import UIKit
import ChameleonFramework

class MainViewController: UIViewController, ENSideMenuDelegate {
    
    @IBOutlet weak var buttonBackground: UIView!
    
    @IBOutlet weak var balanceTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var moneyLeftLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationTrailingConstraint: NSLayoutConstraint!
    
    var menuOpened:Bool = false
    let defaults = NSUserDefaults.standardUserDefaults()
    var notificationWidth = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
//        buttonBackground.backgroundColor = UIColor(red: 247, green: 183, blue: 49, alpha: 0.1)
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.frame = buttonBackground.bounds
//        buttonBackground.addSubview(blurView)
        
        
        defaults.setBool(false, forKey: "onGoingTrip")
        print("Fonts \(UIFont.familyNames())")
        
        askButton.layer.cornerRadius = 5.0
        askButton.backgroundColor = UIColor(gradientStyle: .TopToBottom, withFrame: askButton.frame, andColors: [UIColor(hexString: "F7B731"),UIColor(hexString: "F6A408")])
        
        let users:[QualityUser] = QualityUser.MR_findAll() as! [QualityUser]
        for eachUser:QualityUser in users{
            print(eachUser.name)
        }
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        notificationLabel.text = "Tienes un viaje en curso"
        notificationWidth = self.notificationLabel.frame.size.width
        notificationLeadingConstraint.constant = (notificationWidth + 10) * -1
        notificationTrailingConstraint.constant = notificationTrailingConstraint.constant + notificationWidth
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        moneyLeftLabel.text = String(format: "$%.2f", defaults.floatForKey("moneyLeft"))
    }
    
    override func viewDidAppear(animated: Bool) {
        let onGoingTrip = defaults.boolForKey("onGoingTrip")
        
        if onGoingTrip == true {
            print("ongoing trip!")
            balanceTrailingConstraint.constant = balanceTrailingConstraint.constant + 10
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { 
                self.view.layoutIfNeeded()
                }, completion: { (complete) in
                    self.balanceTrailingConstraint.constant = self.balanceTrailingConstraint.constant - 60 - self.moneyLeftLabel.frame.size.width
                    self.notificationLeadingConstraint.constant = 20
                    self.notificationTrailingConstraint.constant = 20
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { 
                        self.view.layoutIfNeeded()
                        }, completion: nil)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openMenuPressed(sender: AnyObject) {
        print("menu pressed")
        menuOpened = !menuOpened
    }
    
    @IBAction func askTaxi(sender: AnyObject) {
        self.performSegueWithIdentifier("toAskForTaxi", sender: nil)
    }
    
    @IBAction func unwindToStart(segue: UIStoryboardSegue) {}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
