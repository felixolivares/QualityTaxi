//
//  VerificationCodeViewController.swift
//  QualityTaxi
//
//  Created by Developer on 8/3/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class VerificationCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldsContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var code1TextField: UITextField!
    @IBOutlet weak var code2TextField: UITextField!
    @IBOutlet weak var code3TextField: UITextField!
    @IBOutlet weak var code4TextField: UITextField!
    @IBOutlet weak var resendCodeButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    var commingFrom = String()
    var currentUser:QTUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContainerView.layer.cornerRadius = 10
        resendCodeButton.layer.cornerRadius = 5
        
        code1TextField.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        code2TextField.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        code3TextField.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        code4TextField.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)

        print("Current user registred: \(QTUserManager.sharedInstance.currentUser.email)")
        currentUser = QTUserManager.sharedInstance.getCurrentUser()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if commingFrom == "profile" {
            backgroundImageView.hidden = true
        }else{
            backgroundImageView.hidden = false
        }
    }
    @IBAction func cancelButton(sender: AnyObject) {
        print("cancel pressed")
        if commingFrom == "profile" {
            currentUser.phoneIsVerified = false
            QTUserManager.sharedInstance.updateUser(currentUser)
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            self.dismissViewControllerAnimated(true, completion: {})
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        switch textField {
        case code1TextField:
            if code1TextField.text?.characters.count == 1 {
                code2TextField.becomeFirstResponder()
            }
        case code2TextField:
            if code2TextField.text?.characters.count == 1 {
                code3TextField.becomeFirstResponder()
            }
        case code3TextField:
            if code3TextField.text?.characters.count == 1 {
                code4TextField.becomeFirstResponder()
            }
        case code4TextField:
            if (code4TextField.text?.characters.count == 1 && code3TextField.text?.characters.count == 1 && code2TextField.text?.characters.count == 1 && code1TextField.text?.characters.count == 1) {
                self.view.endEditing(true)
                _ = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(goToProfileInfo), userInfo: nil, repeats: false)
                
            }
        default:
            code1TextField.becomeFirstResponder()
        }
    }
    
    func goToProfileInfo(){
        if commingFrom == "profile" {
            currentUser.phoneIsVerified = true
            QTUserManager.sharedInstance.updateUser(currentUser)
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            currentUser.phoneIsVerified = true
            QTUserManager.sharedInstance.updateUser(currentUser)
            performSegueWithIdentifier("toProfileInfo", sender: self);
        }
    }
    
    @IBAction func resendCodeButtonPressed(sender: AnyObject) {
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
