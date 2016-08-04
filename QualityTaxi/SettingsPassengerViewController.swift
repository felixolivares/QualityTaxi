//
//  SettingsPassengerViewController.swift
//  QualityTaxi
//
//  Created by Developer on 6/27/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit
import ChameleonFramework

class SettingsPassengerViewController: UIViewController, UIGestureRecognizerDelegate {

    var viewTouchOverlayFull = UIView()
    var shadowView = UIView()
    var menuOpened:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewTouchOverlayFull = UIView(frame: self.view.frame)
        viewTouchOverlayFull.backgroundColor = UIColor.clearColor()
        self.view.addSubview(viewTouchOverlayFull)
        let tapOverlay = UITapGestureRecognizer(target: self, action: #selector(touchViewOverlayPressed))
        tapOverlay.delegate = self
        viewTouchOverlayFull.addGestureRecognizer(tapOverlay)
        viewTouchOverlayFull.hidden = true
        
        shadowView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.origin.x,UIScreen.mainScreen().bounds.origin.y,5,UIScreen.mainScreen().bounds.size.height))
        //        shadowView.backgroundColor = UIColor(hexString: "2C2A2A")
        shadowView.backgroundColor = GradientColor(UIGradientStyle.LeftToRight, frame: shadowView.frame, colors: [UIColor.blackColor(), UIColor.clearColor()])
        shadowView.hidden = true
        self.navigationController!.view.addSubview(shadowView)
        
        
        if self.revealViewController() != nil {
            //            menuButton.target = self.revealViewController()
            //            menuButton.action = #selector(self.menuPressed)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().toggleAnimationType = .Spring
            self.revealViewController().rearViewRevealOverdraw = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func touchViewOverlayPressed(){
        viewTouchOverlayFull.hidden = true
        shadowView.hidden = true
        self.revealViewController().revealToggle(self)
        menuOpened = !menuOpened
    }

    @IBAction func openMenuPressed(sender: AnyObject) {
        self.revealViewController().revealToggle(self)
        if !menuOpened {
            viewTouchOverlayFull.hidden = false
            shadowView.hidden = false
        }else{
            viewTouchOverlayFull.hidden = true
            shadowView.hidden = true
        }
        menuOpened = !menuOpened
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
