//
//  LoginViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/25/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var lostPassBackground: UIView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var accessTitleLabel: UILabel!
    
    @IBOutlet weak var createAccountTitleLabel: UILabel!
    @IBOutlet weak var registerContainer: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var forgotPassTitleLabel: UILabel!
    
    @IBOutlet weak var cancelPassBtn: UIButton!
    @IBOutlet weak var sendPassBtn: UIButton!
    var currentUser:QualityUser!
    let defaults = NSUserDefaults.standardUserDefaults()
    var devMode:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if devMode {
            userTextField.text = "pasajero"
            passwordTextField.text = "1234"
        }
        QualityUser.MR_truncateAll()
        QualityTrip.MR_truncateAll()
        
        forgotPassTitleLabel.alpha = 0
        createAccountTitleLabel.alpha = 0
        registerContainer.layer.cornerRadius = 10
        registerContainer.alpha = 0
        backgroundView.layer.cornerRadius = 10
        lostPassBackground.alpha = 0
        lostPassBackground.layer.cornerRadius = 10
        userTextField.delegate = self
        passwordTextField.delegate = self
        
        loginBtn.layer.cornerRadius = 5
        acceptBtn.layer.cornerRadius = 5
        cancelBtn.layer.cornerRadius = 5
        sendPassBtn.layer.cornerRadius = 5
        cancelPassBtn.layer.cornerRadius = 5
        
        defaults.setFloat(55.00, forKey: "moneyLeft")
        defaults.synchronize()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        userTextField.text = ""
        passwordTextField.text = ""
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        self.validateLogin()
        return true
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        self.validateLogin()
    }
    
    func validateLogin(){
        if (userTextField.text == "pasajero" && passwordTextField.text == "1234") {
            currentUser = QualityUser.MR_createEntity()
            currentUser.name = userTextField.text
            self.saveContext()
            performSegueWithIdentifier("toPassenger", sender: self)
        }else if(userTextField.text == "chofer" && passwordTextField.text == "1234"){
            performSegueWithIdentifier("toDriver", sender: self)
        }
    }
    
    @IBAction func createAccountPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: {
            self.backgroundView.alpha = 0
            self.lostPassBackground.alpha = 0
            self.accessTitleLabel.alpha = 0
        }) { (Value) in
            UIView.animateWithDuration(0.4, animations: {
                self.registerContainer.alpha = 1
                self.createAccountTitleLabel.alpha = 1
            })
        }
    }

    //Mark - Unwind segues
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    @IBAction func unwindToLoginFromDriver(segue: UIStoryboardSegue) {}
    
    @IBAction func forgotPassPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: { 
            self.backgroundView.alpha = 0
            self.registerContainer.alpha = 0
            self.createAccountTitleLabel.alpha = 0
            self.accessTitleLabel.alpha = 0
            }) { (Value) in
                UIView.animateWithDuration(0.4, animations: { 
                    self.lostPassBackground.alpha = 1
                    self.forgotPassTitleLabel.alpha = 1
                })
        }
    }
    
    //Recover pass
    @IBAction func sendToRecoverPass(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: { 
            self.lostPassBackground.alpha = 0
            self.forgotPassTitleLabel.alpha = 0
            }) { (value) in
                UIView.animateWithDuration(0.4, animations: { 
                    self.backgroundView.alpha = 1
                    self.accessTitleLabel.alpha = 1
                })
        }
    }
    @IBAction func cancelRecoverPassPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: {
            self.lostPassBackground.alpha = 0
            self.forgotPassTitleLabel.alpha = 0
        }) { (value) in
            UIView.animateWithDuration(0.4, animations: {
                self.backgroundView.alpha = 1
                self.accessTitleLabel.alpha = 1
            })
        }
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    //Register
    @IBAction func acceptPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: {
            self.registerContainer.alpha = 0
            self.createAccountTitleLabel.alpha = 0
        }) { (Value) in
            UIView.animateWithDuration(0.4, animations: {
                self.backgroundView.alpha = 1
                self.accessTitleLabel.alpha = 1
            })
        }
    }
    @IBAction func cancelPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: {
            self.registerContainer.alpha = 0
            self.createAccountTitleLabel.alpha = 0
        }) { (Value) in
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
