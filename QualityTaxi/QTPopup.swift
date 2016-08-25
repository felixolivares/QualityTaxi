//
//  QTPopup.swift
//  QualityTaxi
//
//  Created by Developer on 8/23/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

protocol QTPopupDelegate
{
    func cancelAction()
    func acceptAction()
}

class QTPopup: UIView {
    var mainContainer:UIView!
    var optionsContainer = UIView()
    let cancelButton:UIButton = UIButton()
    let acceptButton:UIButton = UIButton()
    var containerWidth = CGFloat()
    var containerHeigth = CGFloat()
    var topPadding = CGFloat()
    var title:UILabel = UILabel()
    var message:UILabel = UILabel()
    var firstSwitch:AIFlatSwitch!
    var secondSwitch:AIFlatSwitch!
    var thirdSwitch:AIFlatSwitch!
    var firstOptionLabel:UILabel!
    var secondOptionLabel:UILabel!
    var thirdOptionLabel:UILabel!
    
    var delegate:QTPopupDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func configure(){
        containerWidth = self.frame.size.width * 0.65
        containerHeigth = self.frame.size.height * 0.5
        topPadding = 40.0
        
        mainContainer = UIView(frame: CGRectMake((self.frame.size.width - containerWidth)/2, self.frame.size.height, containerWidth, containerHeigth))
        mainContainer.backgroundColor = UIColor(hexString: "FAFAFA")
        mainContainer.layer.cornerRadius = 3
        mainContainer.layer.borderWidth = 1
        mainContainer.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
        mainContainer.layer.shadowColor = UIColor(hexString: "717171").CGColor
        mainContainer.layer.shadowOpacity = 0.5
        mainContainer.layer.shadowOffset = CGSizeZero
        mainContainer.layer.shadowRadius = 4
        self.addSubview(mainContainer)
        
        cancelButton.frame = CGRectMake(mainContainer.frame.size.width / 2,
                                        mainContainer.frame.size.height - 40,
                                        mainContainer.frame.size.width / 2,
                                        mainContainer.frame.size.height-(mainContainer.frame.size.height - 40))
        cancelButton.setTitle("Cancelar", forState: .Normal)
        cancelButton.titleLabel?.font = UIFont(name: "Myriadpro-Semibold", size: 15.0)
        cancelButton.setTitleColor(UIColor(hexString: "1C3F58"), forState: .Normal)
        cancelButton.addTarget(self, action: #selector(QTPopup.cancelButtonPressed), forControlEvents: .TouchUpInside)
        mainContainer.addSubview(cancelButton)
        
        acceptButton.frame = CGRectMake(0,
                                        mainContainer.frame.size.height - 40,
                                        mainContainer.frame.size.width / 2,
                                        mainContainer.frame.size.height-(mainContainer.frame.size.height - 40))
        acceptButton.setTitle("Aceptar", forState: .Normal)
        acceptButton.titleLabel?.font = UIFont(name: "Myriadpro-Semibold", size: 15.0)
        acceptButton.setTitleColor(UIColor(hexString: "1C3F58"), forState: .Normal)
        acceptButton.addTarget(self, action: #selector(QTPopup.acceptButtonPressed), forControlEvents: .TouchUpInside)
        mainContainer.addSubview(acceptButton)
        
        let bottomSeparator:UIView = UIView(frame: CGRectMake(0, acceptButton.frame.origin.y - 1, mainContainer.frame.size.width, 1))
        bottomSeparator.backgroundColor = UIColor(hexString: "E3E3E3")
        mainContainer.addSubview(bottomSeparator)
        
        let buttonSeparator:UIView = UIView(frame: CGRectMake(acceptButton.frame.size.width, acceptButton.frame.origin.y, 1, acceptButton.frame.size.height))
        buttonSeparator.backgroundColor = UIColor(hexString: "E3E3E3")
        mainContainer.addSubview(buttonSeparator)
        
        title = UILabel(frame: CGRectMake(0, 10, mainContainer.frame.size.width, 20))
        title.font = UIFont(name: "Myriadpro-Semibold", size: 16.0)
        title.text = "¿Estas seguro?"
        title.textColor = UIColor(hexString: "1C3F58")
        title.textAlignment = NSTextAlignment.Center
        mainContainer.addSubview(title)
        
        message = UILabel(frame: CGRectMake(10, title.frame.origin.y + title.frame.size.height + 10, mainContainer.frame.size.width - 20, CGFloat.max))
        message.numberOfLines = 0
        message.lineBreakMode = NSLineBreakMode.ByWordWrapping
        message.font = UIFont(name: "Myriadpro-Regular", size: 12.0)
        message.text = "Si realmente deseas cancelar el viaje, por favor indicanos cual es la razon:"
        message.textColor = UIColor(hexString: "1C3F58")
        message.sizeToFit()
        message.frame.origin = CGPointMake(10, title.frame.origin.y + title.frame.size.height + 10)
        mainContainer.addSubview(message)
        
        optionsContainer = UIView(frame: CGRectMake(10, message.frame.origin.y + message.frame.size.height + 10, mainContainer.frame.size.width - 20, mainContainer.frame.size.height - acceptButton.frame.size.height - message.frame.origin.y - message.frame.size.height - 20))
        optionsContainer.backgroundColor = UIColor.whiteColor()
        optionsContainer.layer.borderWidth = 1
        optionsContainer.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
        optionsContainer.layer.cornerRadius = 3
        mainContainer.addSubview(optionsContainer)
        
        firstSwitch = AIFlatSwitch(frame: CGRectMake(10, 10, 20, 20))
        firstSwitch.lineWidth = 1.0
        firstSwitch.strokeColor = UIColor(hexString: "1C3F58")
        firstSwitch.trailStrokeColor = UIColor(hexString: "F6B231")
        firstSwitch.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        optionsContainer.addSubview(firstSwitch)
        
        firstOptionLabel = UILabel(frame: CGRectMake(firstSwitch.frame.origin.x + firstSwitch.frame.size.width + 5, firstSwitch.frame.origin.y, optionsContainer.frame.size.width - firstSwitch.frame.origin.y - firstSwitch.frame.size.width - 10, 20))
        firstOptionLabel.text = "Se ponchó una llanta"
        firstOptionLabel.font = UIFont(name: "Myriadpro-Regular", size: 10.0)
        firstOptionLabel.textColor = UIColor.blackColor()
        optionsContainer.addSubview(firstOptionLabel)
        
        secondSwitch = AIFlatSwitch(frame: CGRectMake(10, firstSwitch.frame.origin.y + firstSwitch.frame.size.height + 20, 20, 20))
        secondSwitch.lineWidth = 1.0
        secondSwitch.strokeColor = UIColor(hexString: "1C3F58")
        secondSwitch.trailStrokeColor = UIColor(hexString: "F6B231")
        secondSwitch.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        optionsContainer.addSubview(secondSwitch)
        
        secondOptionLabel = UILabel(frame: CGRectMake(secondSwitch.frame.origin.x + secondSwitch.frame.size.width + 5, secondSwitch.frame.origin.y, optionsContainer.frame.size.width - secondSwitch.frame.origin.y - secondSwitch.frame.size.width - 10, 20))
        secondOptionLabel.text = "Se descompuso la unidad"
        secondOptionLabel.font = UIFont(name: "Myriadpro-Regular", size: 10.0)
        secondOptionLabel.textColor = UIColor.blackColor()
        optionsContainer.addSubview(secondOptionLabel)
        
        thirdSwitch = AIFlatSwitch(frame: CGRectMake(10, secondSwitch.frame.origin.y + secondSwitch.frame.size.height + 20, 20, 20))
        thirdSwitch.lineWidth = 1.0
        thirdSwitch.strokeColor = UIColor(hexString: "1C3F58")
        thirdSwitch.trailStrokeColor = UIColor(hexString: "F6B231")
        thirdSwitch.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        optionsContainer.addSubview(thirdSwitch)
        
        thirdOptionLabel = UILabel(frame: CGRectMake(thirdSwitch.frame.origin.x + thirdSwitch.frame.size.width + 5, thirdSwitch.frame.origin.y, optionsContainer.frame.size.width - thirdSwitch.frame.origin.y - thirdSwitch.frame.size.width - 10, 20))
        thirdOptionLabel.text = "Me dio weba hasta alla"
        thirdOptionLabel.font = UIFont(name: "Myriadpro-Regular", size: 10.0)
        thirdOptionLabel.textColor = UIColor.blackColor()
        optionsContainer.addSubview(thirdOptionLabel)
        
        
        self.animateFadeIn()
        
    }
    
    func animateFadeIn(){
        print("fade in")
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.mainContainer.frame = CGRectMake((self.frame.size.width - self.containerWidth)/2, self.frame.origin.x + self.topPadding, self.containerWidth, self.containerHeigth)
            }) { (complete) in }
    }
    
    func animateFadeOut(){
        UIView.animateWithDuration(0.2) {
            self.mainContainer.frame = CGRectMake((self.frame.size.width - self.containerWidth)/2, self.frame.size.height, self.containerWidth, self.containerHeigth)
        }
    }
    
    func cancelButtonPressed(){
        print("Cancel pressed")
        self.animateFadeOut()
        delegate?.cancelAction()
    }
    
    func acceptButtonPressed(){
        print("Accept pressed")
        self.animateFadeOut()
        delegate?.acceptAction()
    }
}
