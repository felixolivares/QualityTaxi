//
//  QTTrip.swift
//  QualityTaxi
//
//  Created by Developer on 8/8/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class QTTrip: NSObject {

    override init() {
        super.init()
    }
    
    var carColor:String? = String()
    var carKind:String? = String()
    var carPlates:String? = String()
    var createdAt:String? = String()
    var destinationColony:String? = String()
    var destinationLatitude:String? = String()
    var destinationLongitude:String? = String()
    var destinationStreet:String? = String()
    var driverName:String? = String()
    var driverPhoto:String? = String()
    var isActive:Bool? = Bool()
    var originColony:String? = String()
    var originLatitude:String? = String()
    var originLongitude:String? = String()
    var originStreet:String? = String()
    var rate:String? = String()
    var sentAt:String? = String()
    var timeAprox:String? = String()
    var totalDistance:String? = String()
    var tripImage:NSData? = NSData()
}
