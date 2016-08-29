//
//  QTAlertView.swift
//  QualityTaxi
//
//  Created by Felix on 8/28/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class QTAlertView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        print("alert added")
        let blurView = DynamicBlurView(frame: CGRectMake(50, 50, 50, 50))        
        self.addSubview(blurView)
        blurView.blurRadius = 12
        
    }
}
