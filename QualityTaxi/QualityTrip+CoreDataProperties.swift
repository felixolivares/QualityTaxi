//
//  QualityTrip+CoreDataProperties.swift
//  
//
//  Created by Developer on 4/28/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension QualityTrip {

    @NSManaged var destinationColony: String?
    @NSManaged var destinationLatitude: String?
    @NSManaged var destinationLongitude: String?
    @NSManaged var destinationStreet: String?
    @NSManaged var originColony: String?
    @NSManaged var originLatitude: String?
    @NSManaged var originLongitude: String?
    @NSManaged var originStreet: String?
    @NSManaged var createdAt: String?
    @NSManaged var sentAt: String?

}
