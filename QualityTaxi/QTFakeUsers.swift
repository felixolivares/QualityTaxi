//
//  QTFakeUsers.swift
//  QualityTaxi
//
//  Created by Developer on 8/10/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class QTFakeUsers: NSObject {

    var newUser:QualityUser!
    var passengerUser:QualityUser!
    var driverUser:QualityUser!
    
    override init() {
        super.init()
    }
    
    func createUsers(){
        print("Fake users created")
        
        newUser = QualityUser.MR_createEntity()
        newUser.email = "pedro@gmail.com"
        newUser.lastName = "Rodriguez"
        newUser.name = "Pedro"
        newUser.password = "pe"
        newUser.phoneNumber = "3112143245"
        newUser.photo = ""
        newUser.phoneIsVerified = false
//        self.saveContext()
        
        passengerUser = QualityUser.MR_createEntity()
        passengerUser.email = "pasajero@gmail.com"
        passengerUser.lastName = ""
        passengerUser.name = "pasajero"
        passengerUser.password = "1234"
        passengerUser.phoneNumber = ""
        passengerUser.photo = ""
        passengerUser.phoneIsVerified = false
//        self.saveContext()
        
        driverUser = QualityUser.MR_createEntity()
        driverUser.email = "chofer@gmail.com"
        driverUser.lastName = ""
        driverUser.name = "chofer"
        driverUser.password = "1234"
        driverUser.phoneNumber = ""
        driverUser.photo = ""
        driverUser.phoneIsVerified = false
        self.saveContext()
        
        print(QualityUser.MR_countOfEntities())
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
}

