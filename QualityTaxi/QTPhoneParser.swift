//
//  QTPhoneParser.swift
//  QualityTaxi
//
//  Created by Developer on 8/11/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class QTPhoneParser {
    
    func cleanPhone(phone:String) -> String{
        var phoneCleaned = phone.stringByReplacingOccurrencesOfString("(", withString: "")
        phoneCleaned = phoneCleaned.stringByReplacingOccurrencesOfString(")", withString: "")
        phoneCleaned = phoneCleaned.stringByReplacingOccurrencesOfString("-", withString: "")
        phoneCleaned = phoneCleaned.stringByReplacingOccurrencesOfString(" ", withString: "")
        return phoneCleaned
    }
    
    func formatPhone(phone:String) -> String{
        var formattedPhone = phone.insert("(", ind: 0)
        formattedPhone = formattedPhone.insert(")", ind: 4)
        formattedPhone = formattedPhone.insert("-", ind: 8)
        return formattedPhone
    }
}

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}