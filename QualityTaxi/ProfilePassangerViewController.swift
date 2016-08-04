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

class ProfilePassangerViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    var viewTouchOverlayFull = UIView()
    var shadowView = UIView()
    var menuOpened:Bool = false
    var editMode:Bool = false
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfilePassangerViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
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
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        editMode = !editMode
        
        if editMode == true {
            //Is editing
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
            }) { (finished) in
                UIView.animateWithDuration(0.2, animations: {
                    self.editEmailTextField.alpha = 1
                    self.editPhoneNumberTextField.alpha = 1
                    self.editPhotoView.alpha = 1
                    self.editNameTextField.alpha = 1
                    self.saveButton.alpha = 1
                })
            }
            
        }else{
            //Cancel editing
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
                    })
            })
            
            //Reset text fields
            self.editEmailTextField.text = ""
            self.editNameTextField.text = ""
            self.editPhoneNumberTextField.text = ""
            self.view.endEditing(true)
        }
        
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        editMode = !editMode
        editButton.title = "Editar"
        
        if editEmailTextField.text?.characters.count > 0 {
            self.emailLabel.text = self.editEmailTextField.text
        }
        if editPhoneNumberTextField.text?.characters.count > 0 {
            self.phoneNumberLabel.text = self.editPhoneNumberTextField.text
        }
        if editNameTextField.text?.characters.count > 0 {
            self.fullNameLabel.text = self.editNameTextField.text
        }
        
        UIView.animateWithDuration(0.3, animations: {
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
                })
        })
        
        //Reset text fields
        self.editEmailTextField.text = ""
        self.editNameTextField.text = ""
        self.editPhoneNumberTextField.text = ""
        self.view.endEditing(true)

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
