//
//  DriverMainViewController.swift
//  QualityTaxi
//
//  Created by Developer on 5/4/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit


class DriverMainViewController: UIViewController, ENSideMenuDelegate {

    @IBOutlet weak var switchContainerView: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        let runkeeperSwitch = DGRunkeeperSwitch(titles: ["Disponible", "Ocupado"])
//        let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Feed", rightTitle: "Leaderboard")
        runkeeperSwitch.backgroundColor = UIColor(hexString: "F6B231")
        runkeeperSwitch.selectedBackgroundColor = UIColor(hexString: "1C3F58")
        runkeeperSwitch.titleColor = UIColor(hexString: "1C3F58")
        runkeeperSwitch.selectedTitleColor = .whiteColor()
        runkeeperSwitch.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: 50.0, y: 10.0, width: switchContainerView.bounds.width - 100.0, height: 30.0)
        runkeeperSwitch.autoresizingMask = [.FlexibleWidth]
        switchContainerView.addSubview(runkeeperSwitch)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func toggleMenu(sender: AnyObject) {
        print("menu button pressed")
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
