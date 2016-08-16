//
//  ProfilePassangerViewController.swift
//  QualityTaxi
//
//  Created by Developer on 6/27/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit
import ChameleonFramework
import FontAwesome_swift


class ProfilePassangerViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var viewTouchOverlayFull = UIView()
    var shadowView = UIView()
    var menuOpened:Bool = false
    var editMode:Bool = false
    var phoneVerified:Bool = false
    var picker:UIImagePickerController?=UIImagePickerController()
    var profilePic = UIImage()
    var documentsDirectoryURL = NSURL()
    let kProfilePicName = "profileImage.png"
    var currentUser:QTUser! = QTUser()
    var phoneValidationStatus:LoginViewController.ValidatePhoneEmail! = .UnverifiedPhone
    var emailValidationStatus:LoginViewController.ValidatePhoneEmail! = .UnverifiedEmail
    
    @IBOutlet weak var pencilLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var editPhotoView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var editEmailTextField: UITextField!
    @IBOutlet weak var editPhoneNumberTextField: UITextField!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var verifyIcon: UIImageView!
    @IBOutlet weak var verifyPhoneLinkLabel: UILabel!
    
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup side menu
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().toggleAnimationType = .Spring
            self.revealViewController().rearViewRevealOverdraw = 0
        }
        
        
        
        documentsDirectoryURL = try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfilePassangerViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let tapImage: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfilePassangerViewController.handleTapPhotoProfile))
        editPhotoView.addGestureRecognizer(tapImage)
        
        let tapLinkVerify:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfilePassangerViewController.handleTapLinkVerify))
        verifyPhoneLinkLabel.addGestureRecognizer(tapLinkVerify)
        
        self.createVerifyLink("aqui")
        
        //Check if profile image already exists, if so, display it
        let fileURL = documentsDirectoryURL.URLByAppendingPathComponent(kProfilePicName)
        if NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!){
            profilePicImageView.image = UIImage(named: fileURL.path!)
        }
        
        //Add touch overlay for side menu
        self.addTouchOverlay()                        
        
        //Set edit components invisible at the begining
        editPhotoView.alpha = 0
        editEmailTextField.alpha = 0
        editPhoneNumberTextField.alpha = 0
        editNameTextField.alpha = 0
        saveButton.alpha = 0
        
        pencilLabel.text = String.fontAwesomeIconWithCode("fa-pencil")
        pencilLabel.font = UIFont.fontAwesomeOfSize(17)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        currentUser = QTUserManager.sharedInstance.getCurrentUser()
        phoneVerified = currentUser.phoneIsVerified!
        self.fillInfo()
        
        //Check verified phone
        self.checkPhoneVerification()
        
    }
    
    override func viewDidLayoutSubviews() {
        //Create circular profile photo
        self.addCircleMaskToProfileImage(profilePicImageView.frame, borderWidth: 2.0, borderColor: UIColor.whiteColor())
    }
    func touchViewOverlayPressed(){
        viewTouchOverlayFull.hidden = true
        shadowView.hidden = true
        self.revealViewController().revealToggle(self)
        menuOpened = !menuOpened
    }
    
    //MARK: Buttons
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
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        editMode = !editMode
        if currentUser.email != "" {
            emailValidationStatus = .ValidEmail
        }
        if currentUser.phoneNumber != "" {
            phoneValidationStatus = .ValidPhone
        }
        
        if editMode == true {
            //Is editing
            self.editFadeIn()
        }else{
            //Cancel editing
            self.editFadeOut()
        }
        
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if (phoneValidationStatus.rawValue == LoginViewController.ValidatePhoneEmail.WrongPhoneLength.rawValue) {
            let alert = UIAlertController(title: "Verifca tu numero de telefono",
                                          message: "El numero de telefono no esta completo, por favor verificalo.",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            if phoneValidationStatus.rawValue == LoginViewController.ValidatePhoneEmail.WrongPhone.rawValue {
                let alert = UIAlertController(title: "Verifca tu numero de telefono",
                                              message: "El numero de telefono no es válido, por favor verificalo.",
                                              preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                if phoneValidationStatus.rawValue == LoginViewController.ValidatePhoneEmail.ValidPhone.rawValue {
                    if emailValidationStatus.rawValue == LoginViewController.ValidatePhoneEmail.ValidEmail.rawValue {
                        self.saveProfile()
                    }else{
                        let alert = UIAlertController(title: "Verifca tu correo electronico",
                                                      message: "El correo electronico proporcionado no es válido, por favor verficialo.",
                                                      preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }else{
                    if emailValidationStatus.rawValue == LoginViewController.ValidatePhoneEmail.UnverifiedEmail.rawValue {
                        let alert = UIAlertController(title: "Verifca tu telefono y correo",
                                                      message: "El numero de telefono y tu correo electronico no son válidos, por favor verificalo.",
                                                      preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Ingresa un numero de telefono",
                                                      message: "Por favor ingresa un numero de telefono el cual podras verificar mas tarde.",
                                                      preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    //MARK: Save profile
    func saveProfile(){
        editMode = !editMode
        editButton.title = "Editar"
        
        if editEmailTextField.text?.characters.count > 0 {
            //            self.emailLabel.text = self.editEmailTextField.text
            currentUser.email = self.editEmailTextField.text
        }
        if editPhoneNumberTextField.text?.characters.count > 0 {
            //            self.phoneNumberLabel.text = self.editPhoneNumberTextField.text
            currentUser.phoneNumber = self.editPhoneNumberTextField.text
        }
        if editNameTextField.text?.characters.count > 0 {
            //            self.fullNameLabel.text = self.editNameTextField.text
            currentUser.name = self.editNameTextField.text
        }
        QTUserManager.sharedInstance.updateUser(currentUser)
        self.editFadeOut()
        self.fillInfo()
    }
    
    func fillInfo(){
        fullNameLabel.text = currentUser.name! + " " + currentUser.lastname!
        emailLabel.text = currentUser.email!
        phoneNumberLabel.text = currentUser.phoneNumber
        
        let phoneExists = currentUser.phoneNumber == "" ? true : false
        verifyIcon.hidden = phoneExists
        verifyLabel.hidden = phoneExists
        verifyPhoneLinkLabel.hidden = phoneExists
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func editFadeIn(){
        editEmailTextField.placeholder = emailLabel.text
        editPhoneNumberTextField.placeholder = phoneNumberLabel.text
        editNameTextField.placeholder = fullNameLabel.text
        editNameTextField.becomeFirstResponder()
        editButton.title = "Cancelar"
        UIView.animateWithDuration(0.3, animations: {
            self.emailLabel.alpha = 0
            self.phoneNumberLabel.alpha = 0
            self.fullNameLabel.alpha = 0
            self.verifyIcon.alpha = 0
            self.verifyLabel.alpha = 0
            if !self.phoneVerified{
                self.verifyPhoneLinkLabel.alpha = 0
            }
        }) { (finished) in
            UIView.animateWithDuration(0.2, animations: {
                self.editEmailTextField.alpha = 1
                self.editPhoneNumberTextField.alpha = 1
                self.editPhotoView.alpha = 1
                self.editNameTextField.alpha = 1
                self.saveButton.alpha = 1
            })
        }
    }
    
    func editFadeOut(){
        editButton.title = "Editar"
        
        UIView.animateWithDuration(0.2, animations: {
            self.editEmailTextField.alpha = 0
            self.editPhoneNumberTextField.alpha = 0
            self.editPhotoView.alpha = 0
            self.editNameTextField.alpha = 0
            self.saveButton.alpha = 0
            }, completion: { (finish) in
                UIView.animateWithDuration(0.2, animations: {
                    self.emailLabel.alpha = 1
                    self.phoneNumberLabel.alpha = 1
                    self.fullNameLabel.alpha = 1
                    self.verifyIcon.alpha = 1
                    self.verifyLabel.alpha = 1
                    if !self.phoneVerified{
                        self.verifyPhoneLinkLabel.alpha = 1
                    }
                })
        })
        
        //Reset text fields
        self.editEmailTextField.text = ""
        self.editNameTextField.text = ""
        self.editPhoneNumberTextField.text = ""
        self.view.endEditing(true)
    }
    
    //MARK: Handle taps
    func handleTapPhotoProfile(){
        print("tap edit photo")
        let alert:UIAlertController=UIAlertController(title: "Escoge una imagen", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camara", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Galeria de Fotos", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func handleTapLinkVerify(){
        let alert = UIAlertController(title: "Validaremos tu numero de telefono",
                                      message: "Te enviaremos un mensaje SMS con un codigo que deberás introducir a continuación para verificar tu numero de teléfono. ¿Deseas continuar?",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Cancel, handler: nil))
        let continueAction = UIAlertAction(title: "Continuar", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("toVerifyCode", sender: self)
        }
        alert.addAction(continueAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Media
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            picker!.allowsEditing = true;
            picker!.delegate = self;
            picker!.cropMode = .Circular

            
            /*
            //Create camera overlay
            let pickerFrame = CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.size.height, picker!.view.bounds.width, picker!.view.bounds.height - picker!.navigationBar.bounds.size.height - picker!.toolbar.bounds.size.height)
            let squareFrame = CGRectMake(pickerFrame.width/2 - 400/2, pickerFrame.height/2 - 400/2, 400, 400)
            UIGraphicsBeginImageContext(pickerFrame.size)
            
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context)
            CGContextAddRect(context, CGContextGetClipBoundingBox(context))
            CGContextMoveToPoint(context, squareFrame.origin.x, squareFrame.origin.y)
            CGContextAddLineToPoint(context, squareFrame.origin.x + squareFrame.width, squareFrame.origin.y)
            CGContextAddLineToPoint(context, squareFrame.origin.x + squareFrame.width, squareFrame.origin.y + squareFrame.size.height)
            CGContextAddLineToPoint(context, squareFrame.origin.x, squareFrame.origin.y + squareFrame.size.height)
            CGContextAddLineToPoint(context, squareFrame.origin.x, squareFrame.origin.y)
            CGContextEOClip(context)
            CGContextMoveToPoint(context, pickerFrame.origin.x, pickerFrame.origin.y)
            CGContextSetRGBFillColor(context, 0, 0, 0, 1)
            CGContextSetAlpha(context,0.5)
            CGContextFillRect(context, pickerFrame)
            CGContextRestoreGState(context)
            
            let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext();
            
            let overlayView = UIImageView(frame: pickerFrame)
            overlayView.image = overlayImage
            picker!.cameraOverlayView = overlayView
             */
            
            
            self .presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker!.allowsEditing = true;
        picker!.cropMode = .Circular
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            self.presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK: Image picker delegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker .dismissViewControllerAnimated(true, completion: nil)
        profilePic = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        profilePicImageView.image = profilePic
//        profilePicImageView.layer.borderWidth = 2
//        profilePicImageView.layer.borderColor = UIColor.greenColor().CGColor
        
        let fileURL = documentsDirectoryURL.URLByAppendingPathComponent(kProfilePicName)
        if UIImageJPEGRepresentation(profilePic, 1.0)!.writeToFile(fileURL.path!, atomically: true) {
            print("file saved")
        } else {
            print("error saving file")
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("picker cancel.")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addCircleMaskToProfileImage(frame:CGRect, borderWidth:CGFloat, borderColor:UIColor){
        profilePicImageView.clipsToBounds = true
        profilePicImageView.contentMode = UIViewContentMode.ScaleAspectFill
        let maskBounds:CGRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
        
        //Add circle mask to image view
        let maskLayer:CAShapeLayer = CAShapeLayer()
        let maskPath:CGPathRef = CGPathCreateWithEllipseInRect(maskBounds, nil)
        maskLayer.bounds = maskBounds
        maskLayer.path = maskPath
        maskLayer.fillColor = UIColor.blackColor().CGColor
        let point:CGPoint = CGPointMake((maskBounds.size.width)/2, (maskBounds.size.height)/2)
        maskLayer.position = point
        profilePicImageView.layer.mask = maskLayer
        
        //Add border
        let shape:CAShapeLayer = CAShapeLayer()
        shape.bounds = maskBounds
        shape.path = maskPath
        shape.lineWidth = borderWidth * 2.0
        shape.strokeColor = borderColor.CGColor
        shape.fillColor = UIColor.clearColor().CGColor
        shape.position = point
        profilePicImageView.layer.addSublayer(shape)
        
        self.profilePicImageView.setNeedsDisplay()
    }
    
    func checkPhoneVerification(){
        if phoneVerified {
            verifyIcon.image = UIImage(named: "greenCheckmark")
            verifyLabel.text = "Verificado"
            verifyPhoneLinkLabel.alpha = 0
        }else{
            verifyIcon.image = UIImage(named: "exclamationMark")
            verifyLabel.text = "No Verificado"
            verifyPhoneLinkLabel.alpha = 1
        }
    }
    
    func createVerifyLink(substring:String){
        let fontSize:CGFloat = 11.0
        let attrs:[String:AnyObject] = [NSFontAttributeName:UIFont.systemFontOfSize(fontSize),
                                        NSForegroundColorAttributeName:UIColor.blackColor()]
        let subAttrs:[String:AnyObject] = [NSFontAttributeName:UIFont.boldSystemFontOfSize(fontSize),
                                           NSForegroundColorAttributeName:UIColor(rgb: 0x183C58),
                                           NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleDouble.rawValue]
//        let range = verifyPhoneLinkLabel.text!.rangeOfString(substring)
        let range:NSRange = NSMakeRange(39, 14)
        let attributedText:NSMutableAttributedString = NSMutableAttributedString.init(string: verifyPhoneLinkLabel.text!, attributes: attrs)
        attributedText.addAttributes(subAttrs, range: range)
        verifyPhoneLinkLabel.attributedText = attributedText
    }
    
    func addTouchOverlay(){
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
    }
    
    //MARK: Textfield delegate functions
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == editPhoneNumberTextField
        {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                return (newLength > 10) ? false : true
            }else{
                if length >= 10{
                    phoneValidationStatus = .ValidPhone
                    print("validation : \(phoneValidationStatus)")
                }else{
                    phoneValidationStatus = .WrongPhoneLength
                    print("validation : \(phoneValidationStatus)")
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
        }
        else
        {
            if textField == editEmailTextField {
                if QTValidation().emailValidation(editEmailTextField.text!) {
                    emailValidationStatus = .ValidEmail
                    print("validation : \(emailValidationStatus)")
                }else{
                    emailValidationStatus = .UnverifiedEmail
                    print("validation : \(emailValidationStatus)")
                }
                return true
            }else{
                return true
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toVerifyCode" {
            let vc:VerificationCodeViewController = segue.destinationViewController as! VerificationCodeViewController
            vc.commingFrom = "profile"
        }
    }
}
