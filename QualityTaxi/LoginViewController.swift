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
    
    var currentUser:QualityUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        QualityUser.MR_truncateAll()
        QualityTrip.MR_truncateAll()
        
        backgroundView.layer.cornerRadius = 10
        lostPassBackground.alpha = 0
        lostPassBackground.layer.cornerRadius = 10
        userTextField.delegate = self
        passwordTextField.delegate = self
        
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
    }

    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    @IBAction func unwindToLoginFromDriver(segue: UIStoryboardSegue) {}
    
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
    
    func saveContext(){
//        NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
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
