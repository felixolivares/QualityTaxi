//
//  QTUser.swift
//  QualityTaxi
//
//  Created by Developer on 8/8/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class QTUser: NSObject {

    override init() {
        super.init()
    }
    
    var email:String? = String()
    var lastname:String? = String()
    var name:String? = String()
    var password:String? = String()
    var phoneNumber:String? = String()
    var photo:String? = String()
    var phoneIsVerified:Bool? = Bool()
    
    func displayUser(){
        if let _ = name{
            print("Name: \(name!)")
        }
        if let _ = lastname{
            print("Lastname: \(lastname!)")
        }
        if let _ = email{
            print("Email: \(email!)")
        }
        if let _ = password{
            print("Pass: \(password!)")
        }
        if let _ = phoneNumber{
            print("Phone Number :\(phoneNumber!)")
        }
        if let _ = photo{
            print("Photo: \(photo!)")
        }
        
        if (phoneIsVerified != nil) {
            print("Phone is Verified")
        }else{
            print("Phone is not Verified")
        }
    }
}
