//
//  QTUserManager.swift
//  QualityTaxi
//
//  Created by Developer on 8/5/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class QTUserManager{
    static let sharedInstance = QTUserManager()
    
    var currentUser:QualityUser!
    
    private init() {
        print("User Manager Init")
        print(#function)        
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func displayCurrentUser(){
        print(" Name: \(currentUser.name!)\n Lastname: \(currentUser.lastName!)\n Email: \(currentUser.email!)\n Password: \(currentUser.password!)\n Phone Number: \(currentUser.phoneNumber!)\n Photo: \(currentUser.photo!)")
    }
    
    func updateUser(user:QTUser){
        currentUser.name = user.name
        currentUser.lastName = user.lastname
        currentUser.email = user.email
        currentUser.password = user.password
        currentUser.phoneNumber = user.phoneNumber
        currentUser.photo = user.photo
        currentUser.phoneIsVerified = user.phoneIsVerified
        
        self.saveContext()
        
    }
    
    func updateTrip(trip:QTTrip){
        //Trip
        currentUser.trip?.carColor = trip.carColor
        currentUser.trip?.carKind = trip.carKind
        currentUser.trip?.carPlates = trip.carPlates
        currentUser.trip?.createdAt = trip.createdAt
        currentUser.trip?.destinationColony = trip.destinationColony
        currentUser.trip?.destinationLatitude = trip.destinationLatitude
        currentUser.trip?.destinationLongitude = trip.destinationLongitude
        currentUser.trip?.destinationStreet = trip.destinationStreet
        currentUser.trip?.driverName = trip.driverName
        currentUser.trip?.driverPhoto = trip.driverPhoto
        currentUser.trip?.originColony = trip.originColony
        currentUser.trip?.originLatitude = trip.originLatitude
        currentUser.trip?.originLongitude = trip.originLongitude
        currentUser.trip?.originStreet = trip.originStreet
        currentUser.trip?.rate = trip.rate
        currentUser.trip?.sentAt = trip.sentAt
        currentUser.trip?.timeAprox = trip.timeAprox
        currentUser.trip?.totalDistance = trip.totalDistance
        currentUser.trip?.tripImage = trip.tripImage
        currentUser.trip?.isActive = trip.isActive
        
        self.saveContext()
    }
    
    func getCurrentTrip() -> QTTrip{
        let trip = QTTrip()
        trip.carColor = currentUser.trip?.carColor
        trip.carKind = currentUser.trip?.carKind
        trip.carPlates = currentUser.trip?.carPlates
        trip.createdAt = currentUser.trip?.createdAt
        trip.destinationColony = currentUser.trip?.destinationColony
        trip.destinationLatitude = currentUser.trip?.destinationLatitude
        trip.destinationLongitude = currentUser.trip?.destinationLongitude
        trip.destinationStreet = currentUser.trip?.destinationStreet
        trip.driverName = currentUser.trip?.driverName
        trip.driverPhoto = currentUser.trip?.driverPhoto
        trip.originColony = currentUser.trip?.originColony
        trip.originLatitude = currentUser.trip?.originLatitude
        trip.originLongitude = currentUser.trip?.originLongitude
        trip.originStreet = currentUser.trip?.originStreet
        trip.rate = currentUser.trip?.rate
        trip.sentAt = currentUser.trip?.sentAt
        trip.timeAprox = currentUser.trip?.timeAprox
        trip.totalDistance = currentUser.trip?.totalDistance
        trip.tripImage = currentUser.trip?.tripImage
        trip.isActive = currentUser.trip?.isActive as? Bool
        return trip
    }
    
    func getCurrentUser() -> QTUser{
        let user = QTUser()
        user.name = currentUser.name
        user.lastname = currentUser.lastName
        user.email = currentUser.email
        user.password = currentUser.password
        user.phoneNumber = currentUser.phoneNumber
        user.photo = currentUser.photo
        user.phoneIsVerified = currentUser.phoneIsVerified as? Bool
        
        return user
    }
    
    func parseUser(user:QualityUser) -> QTUser{
        let parsedUser = QTUser()
        parsedUser.name = user.name
        parsedUser.lastname = user.lastName
        parsedUser.email = user.email
        parsedUser.password = user.password
        parsedUser.phoneNumber = user.phoneNumber
        parsedUser.photo = user.photo
        parsedUser.phoneIsVerified = user.phoneIsVerified as? Bool
        
        return parsedUser
    }
}
