//
//  LoginViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/25/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController, UITextFieldDelegate {

    enum ValidatePhoneEmail: Int {
        case UnverifiedEmail = -20
        case UnverifiedPhone = -15
        case WrongPhone = -10
        case WrongPhoneLength = -5
        case WrongEmail = 0
        case ValidPhone = 5
        case ValidEmail = 10
    }
    
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
    
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var cancelPassBtn: UIButton!
    @IBOutlet weak var sendPassBtn: UIButton!
    @IBOutlet weak var emailOrPhoneRegisterLabel: UILabel!
    @IBOutlet weak var passwordRegisterLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    //Mark - Unwind segues
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    @IBAction func unwindToLoginFromDriver(segue: UIStoryboardSegue) {}
    
    var currentUser:QTUser!
    var userToLogin:QTUser!
    let defaults = NSUserDefaults.standardUserDefaults()
    var outFrom:String = ""
    
    var devMode:Bool = true
    
    var isValidEmail = false
    var validation:ValidatePhoneEmail!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if devMode {
            userTextField.text = "pasajero"
            passwordTextField.text = "1234"
        }    
        
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
        
        let user = "quality"
        let password = "taxbitch"
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(.GET, "http://www.qualitytaxi.com.mx/", headers: headers)
            .responseString { response in
//                debugPrint(response)
        }
        
        validation = .UnverifiedPhone
        print("validation : \(validation)")
        currentUser = QTUser()
//        QTUserManager.sharedInstance.currentUser = QualityUser.MR_createEntity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        userTextField.text = ""
        passwordTextField.text = ""
        switch outFrom {
        case "register":
            self.transitionFromRegisterToLogin()
        case "forgot":
            self.transitionFromForgotPassToLogin()
        default:
            print("")
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: Textfield delegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        self.validateLogin()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == mailTextField || textField == userTextField)
        {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            //Phone number validation
            let resultPhoneNumberValidation = QTValidation().threeDigitValidation(newString)
            
            if (resultPhoneNumberValidation == true ||  length >= 3){
                print("length: \(length)")
                
                if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
                {
                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                    return (newLength > 10) ? false : true
                }else{
                    if length >= 10{
                        validation = .ValidPhone
                        print("validation : \(validation)")
                    }else{
                        validation = .WrongPhoneLength
                        print("validation : \(validation)")
                    }
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
                if textField == userTextField {
                    if QTValidation().emailValidation(textField.text!) {
                        validation = .ValidEmail
                    }else{
                        validation = .UnverifiedEmail
                    }
                }else{
                    validation = .UnverifiedPhone
                }
                print("validation : \(validation)")
                return true
            }
        }
        else
        {
            return true
        }
    }
    
    // MARK: Login methods
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if userTextField.text?.characters.count > 0 {
            if let user:QualityUser = QualityUser.MR_findFirstByAttribute("email", withValue: userTextField.text!){
                userToLogin = QTUserManager.sharedInstance.parseUser(user)
                self.validateLogin()
            }else{
                if let user:QualityUser = QualityUser.MR_findFirstByAttribute("phoneNumber", withValue: userTextField.text!){
                    userToLogin = QTUserManager.sharedInstance.parseUser(user)
                    self.validateLogin()
                }else{
                    if let user:QualityUser = QualityUser.MR_findFirstByAttribute("name", withValue: userTextField.text!){
                        userToLogin = QTUserManager.sharedInstance.parseUser(user)
                        self.validateLogin()
                        
                    }else{
                        let alert = UIAlertController(title: "Verifica tu correo electronico",
                                                      message: "El correo proporcionado no existe, por favor verificalo.",
                                                      preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func validateLogin(){
        if passwordTextField.text?.characters.count > 0 {
            if userToLogin.password == passwordTextField.text! {
                QTUserManager.sharedInstance.currentUser = QualityUser.MR_createEntity()
                QTUserManager.sharedInstance.updateUser(userToLogin)
                QTUserManager.sharedInstance.displayCurrentUser()
                if userToLogin.name == "chofer" {
                    performSegueWithIdentifier("toDriver", sender: self)
                }else{
                    performSegueWithIdentifier("toPassenger", sender: self)
                }
            }else{
                let alert = UIAlertController(title: "Verifca tu contraseña",
                                              message: "La contraseña introducida no es correcta, por favor verficiala de nuevo.",
                                              preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Verifca tu contraseña",
                                          message: "Por favor introduce tu contraseña.",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Create Account
    @IBAction func createAccountPressed(sender: AnyObject) {
        self.transitionFromLoginToRegister()
    }
    
    @IBAction func forgotPassPressed(sender: AnyObject) {
        self.transitionFromLoginToForgotPass()
    }
    
    // MARK: Recover pass
    @IBAction func sendToRecoverPass(sender: AnyObject) {
        self.transitionFromForgotPassToLogin()
    }
    @IBAction func cancelRecoverPassPressed(sender: AnyObject) {
        self.transitionFromForgotPassToLogin()
    }
    
    //MARK: Register
    @IBAction func acceptPressed(sender: AnyObject) {
        if (validation.rawValue == ValidatePhoneEmail.WrongPhoneLength.rawValue) {
            let alert = UIAlertController(title: "Verifca tu numero de telefono",
                                          message: "El numero de telefono no esta completo, por favor verificalo.",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            if validation.rawValue == ValidatePhoneEmail.WrongPhone.rawValue {
                let alert = UIAlertController(title: "Verifca tu numero de telefono",
                                              message: "El numero de telefono no es valido, por favor verificalo.",
                                              preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                if validation.rawValue == ValidatePhoneEmail.ValidPhone.rawValue {
                    self.validateAndSave()
                }else{
                    if !QTValidation().emailValidation(mailTextField.text!){
                        let alert = UIAlertController(title: "Verifca tu correo electronico",
                                                      message: "El correo electronico proporcionado no es valido, por favor verficialo.",
                                                      preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }else{
                        validation = .ValidEmail
                        self.validateAndSave()
                    }
                }
            }
        }
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.transitionFromRegisterToLogin()
    }
    
    func validateAndSave(){
        QTUserManager.sharedInstance.currentUser = QualityUser.MR_createEntity()
        //Validate email text field
        if mailTextField.text!.characters.count > 0 {
            //Store user's email or phone
            switch validation.rawValue {
            case ValidatePhoneEmail.ValidPhone.rawValue:
                currentUser.phoneNumber = mailTextField.text!
            case ValidatePhoneEmail.ValidEmail.rawValue:
                currentUser.email = mailTextField.text!
            default:
                currentUser.email = mailTextField.text!
            }
            
            emailOrPhoneRegisterLabel.textColor = UIColor.whiteColor()
        }else{
            emailOrPhoneRegisterLabel.textColor = UIColor.redColor()
        }
        
        if confirmPasswordTextField.text!.characters.count == 0 {
            confirmPasswordLabel.textColor = UIColor.redColor()
        }else{
            confirmPasswordLabel.textColor = UIColor.whiteColor()
        }
        
        //Validate password field
        if registerPasswordTextField.text!.characters.count > 0 {
            //Validate confirm password field
            if confirmPasswordTextField.text!.characters.count > 0 && registerPasswordTextField.text == confirmPasswordTextField.text {
                currentUser.password = registerPasswordTextField.text!
                
                //Save the user as current user on the User Manager
                QTUserManager.sharedInstance.updateUser(currentUser)
                currentUser.displayUser()
                //                self.saveContext()
                outFrom = "register"
                passwordRegisterLabel.textColor = UIColor.whiteColor()
                performSegueWithIdentifier("toVerificationCode", sender: self)
            }else{
                confirmPasswordLabel.textColor = UIColor.redColor()
                let alert = UIAlertController(title: "Verifica la contraseña", message: "Las contraseñas no coinciden, por favor verifica que sean iguales.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            passwordRegisterLabel.textColor = UIColor.redColor()
        }
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    //Transitions
    func transitionFromRegisterToLogin(){
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
    
    func transitionFromLoginToRegister(){
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
    
    func transitionFromLoginToForgotPass(){
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
    
    func transitionFromForgotPassToLogin(){
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
