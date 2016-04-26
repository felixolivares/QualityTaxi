//
//  LoginViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/25/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var lostPassBackground: UIView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var accessTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.cornerRadius = 10
        lostPassBackground.alpha = 0
        lostPassBackground.layer.cornerRadius = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if (userTextField.text == "pasajero" && passwordTextField.text == "1234") {
            performSegueWithIdentifier("toPassenger", sender: self)
        }
    }
    
    
    @IBAction func createAccountPressed(sender: AnyObject) {
    }

    
    @IBAction func forgotPassPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: { 
            self.backgroundView.alpha = 0
            self.accessTitleLabel.alpha = 0
            }) { (Value) in
                UIView.animateWithDuration(0.4, animations: { 
                    self.lostPassBackground.alpha = 1
                })
        }
    }
    
    @IBAction func sendToRecoverPass(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: { 
            self.lostPassBackground.alpha = 0
            }) { (value) in
                UIView.animateWithDuration(0.4, animations: { 
                    self.backgroundView.alpha = 1
                    self.accessTitleLabel.alpha = 1
                })
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
