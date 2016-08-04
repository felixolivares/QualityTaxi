//
//  QualityUser+CoreDataProperties.swift
//  
//
//  Created by Developer on 8/4/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension QualityUser {

    @NSManaged var email: String?
    @NSManaged var lastName: String?
    @NSManaged var name: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var photo: String?

}
