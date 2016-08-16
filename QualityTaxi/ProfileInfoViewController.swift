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
    
    var missingField:String! = String()
    var currentUser:QTUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileInfoViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        continueButton.layer.cornerRadius = 5
        mainContainerView.layer.cornerRadius = 10
        
        currentUser = QTUserManager.sharedInstance.getCurrentUser()
        if currentUser.email == "" {
            missingField = "email"
        }else{
            if currentUser.phoneNumber == "" {
                missingField = "phone"
            }
        }
        
        switch missingField {
        case "email":
            emailLabel.text = "Correo Electronico:"
        default:
            emailLabel.text = "Numero de Teléfono:"
        }
        
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
            currentUser.name = nameTextField.text!
            nameLabel.textColor = UIColor.whiteColor()
        }
        if lastnameTextField.text?.characters.count == 0 {
            lastnameLabel.textColor = UIColor.redColor()
        }else{
            currentUser.lastname = lastnameTextField.text!
            lastnameLabel.textColor = UIColor.whiteColor()
        }
        if emailTextField.text?.characters.count == 0 {
            emailLabel.textColor = UIColor.redColor()
        }else{
            emailLabel.textColor = UIColor.whiteColor()
            
            switch missingField {
            case "phone":
                currentUser.phoneNumber = emailTextField.text!
            case "email":
                currentUser.email = emailTextField.text!
            default:
                currentUser.email = emailTextField.text!
            }
        }
        
        if nameTextField.text?.characters.count > 0 && lastnameTextField.text?.characters.count > 0 && emailTextField.text?.characters.count > 0 {
            QTUserManager.sharedInstance.updateUser(currentUser)
            performSegueWithIdentifier("toPassengerStart", sender: self)
        }
    }
    
    //MARK: Text field delegate methods
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == emailTextField
        {
            if missingField == "phone" {
                let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
                let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                
                let decimalString = components.joinWithSeparator("") as NSString
                let length = decimalString.length
                let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
                
                if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
                {
                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                    return (newLength > 10) ? false : true
                }
                var index = 0 as Int
                let formattedString = NSMutableString()
                
                if hasLeadingOne
                {
                    formattedString.appendString("1 ")
                    index += 1
                }
                if (length - index) > 3
                {
                    let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                    formattedString.appendFormat("(%@)", areaCode)
                    index += 3
                }
                if length - index > 3
                {
                    let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                    formattedString.appendFormat("%@-", prefix)
                    index += 3
                }
                
                let remainder = decimalString.substringFromIndex(index)
                formattedString.appendString(remainder)
                textField.text = formattedString as String
                return false
            }else{
                return true
            }
        }
        else
        {
            return true
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
