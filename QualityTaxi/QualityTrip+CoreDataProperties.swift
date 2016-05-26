//
//  QualityTrip+CoreDataProperties.swift
//  
//
//  Created by Developer on 5/24/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension QualityTrip {

    @NSManaged var createdAt: String?
    @NSManaged var destinationColony: String?
    @NSManaged var destinationLatitude: String?
    @NSManaged var destinationLongitude: String?
    @NSManaged var destinationStreet: String?
    @NSManaged var originColony: String?
    @NSManaged var originLatitude: String?
    @NSManaged var originLongitude: String?
    @NSManaged var originStreet: String?
    @NSManaged var sentAt: String?
    @NSManaged var tripImage: NSData?
    @NSManaged var totalDistance: String?
    @NSManaged var timeAprox: String?
    @NSManaged var rate: String?
    @NSManaged var driverName: String?
    @NSManaged var carKind: String?
    @NSManaged var carColor: String?
    @NSManaged var carPlates: String?
    @NSManaged var driverPhoto: String?
    @NSManaged var isActive: NSNumber?

}
