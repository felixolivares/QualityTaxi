//
//  ProfileInfoViewController.swift
//  QualityTaxi
//
//  Created by Developer on 8/3/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class ProfileInfoViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileInfoViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        continueButton.layer.cornerRadius = 5
        mainContainerView.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func continueButtonPressed(sender: AnyObject) {
        if nameTextField.text?.characters.count == 0 {
            nameLabel.textColor = UIColor.redColor()
        }else{
            nameLabel.textColor = UIColor.whiteColor()
        }
        if lastnameTextField.text?.characters.count == 0 {
            lastnameLabel.textColor = UIColor.redColor()
        }else{
            lastnameLabel.textColor = UIColor.whiteColor()
        }
        if emailTextField.text?.characters.count == 0 {
            emailLabel.textColor = UIColor.redColor()
        }else{
            emailLabel.textColor = UIColor.whiteColor()
        }
        
        if nameTextField.text?.characters.count > 0 && lastnameTextField.text?.characters.count > 0 && emailTextField.text?.characters.count > 0 {
            performSegueWithIdentifier("toPassengerStart", sender: self)
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
