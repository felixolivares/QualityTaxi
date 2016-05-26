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
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var menuOpened:Bool = false
    let defaults = NSUserDefaults.standardUserDefaults()
    var notificationWidth = CGFloat()
    var notifLeadingValue = CGFloat()
    var notifTrailingValue = CGFloat()
    var balanceTrailingValue = CGFloat()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
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
        
        //Button is big for clickable area, will shrink image to make it look small
        closeButton.alpha = 0
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        notificationLabel.text = "Tienes un viaje en curso"
        notificationWidth = self.notificationLabel.frame.size.width
        notifLeadingValue = (notificationWidth + 10) * -1
        notifTrailingValue = notificationTrailingConstraint.constant + notificationWidth + 45
        balanceTrailingValue = self.balanceTrailingConstraint.constant
        notificationLeadingConstraint.constant = notifLeadingValue
        notificationTrailingConstraint.constant = notifTrailingValue
        self.view.layoutIfNeeded()
        
        if QualityTrip.MR_countOfEntities() == 0 {
            self.addTrips()
        }
        
        let font = UIFont(name: ".SFUIText-Medium", size: 18)
        let fontDescription = UIFont(name: ".SFUIText-Medium", size: 15)
        
        titleLabel.font = font
        descriptionLabel.font = fontDescription
        
    }
    
    override func viewWillAppear(animated: Bool) {
        moneyLeftLabel.text = String(format: "$%.2f", defaults.floatForKey("moneyLeft"))
    }
    
    override func viewDidAppear(animated: Bool) {
        let onGoingTrip = defaults.boolForKey("onGoingTrip")
        
        if onGoingTrip {
            print("ongoing trip!")
            balanceTrailingConstraint.constant = balanceTrailingConstraint.constant + 10
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { 
                self.view.layoutIfNeeded()
                }, completion: { (complete) in
                    self.balanceTrailingConstraint.constant = self.balanceTrailingConstraint.constant - 60 - self.moneyLeftLabel.frame.size.width
                    self.notificationTrailingConstraint.constant = 35
                    self.notificationLeadingConstraint.constant = 20
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.view.layoutIfNeeded()
                        }, completion: {(complete) in
                            UIView.animateWithDuration(0.3, delay: 0.4, options: .CurveLinear, animations: {
                                self.closeButton.alpha = 1
                                }, completion: nil)
                    }
                )
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
    
    @IBAction func closedButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveLinear, animations: {
            self.closeButton.alpha = 0
            }, completion: nil)
        
        print("ongoing trip!")
        notificationLeadingConstraint.constant = notificationLeadingConstraint.constant + 10
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (complete) in
                self.balanceTrailingConstraint.constant = self.balanceTrailingValue + 8
                self.notificationLeadingConstraint.constant = self.notifLeadingValue
                self.notificationTrailingConstraint.constant = self.notifTrailingValue
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: {(complete) in
                        self.balanceTrailingConstraint.constant = self.balanceTrailingValue
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                            self.view.layoutIfNeeded()
                            }, completion: nil)
                })
        })
    }
    
    func addTrips(){
        let trip1:QualityTrip = QualityTrip.MR_createEntity()!
        trip1.createdAt = "1464119544450"
        trip1.driverName = "Juan Luna"
        trip1.carKind = "Accord"
        trip1.carColor = "Verde"
        trip1.carPlates = "CMD-1352"
        trip1.rate = "$40.00"
        trip1.isActive = false
        trip1.timeAprox = "7 mins"
        
        let trip2:QualityTrip = QualityTrip.MR_createEntity()!
        trip2.createdAt = "1464120558230"
        trip2.driverName = "Luis Orozco"
        trip2.carKind = "Mustang"
        trip2.carColor = "Rojo"
        trip2.carPlates = "CMD-2132"
        trip2.rate = "$35.00"
        trip2.isActive = false
        trip2.timeAprox = "9 mins"
        
        let trip3:QualityTrip = QualityTrip.MR_createEntity()!
        trip3.createdAt = "1464120630403"
        trip3.driverName = "Martin Partida"
        trip3.carKind = "Tsuru"
        trip3.carColor = "Blanco"
        trip3.carPlates = "CMD-5498"
        trip3.rate = "$30.00"
        trip3.isActive = false
        trip3.timeAprox = "12 mins"
        
        self.saveContext()
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
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
