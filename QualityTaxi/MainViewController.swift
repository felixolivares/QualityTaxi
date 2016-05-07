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
    
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
//        buttonBackground.backgroundColor = UIColor(red: 247, green: 183, blue: 49, alpha: 0.1)
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.frame = buttonBackground.bounds
//        buttonBackground.addSubview(blurView)
        
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleMenu(sender: AnyObject) {
//        toggleSideMenuView()
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
