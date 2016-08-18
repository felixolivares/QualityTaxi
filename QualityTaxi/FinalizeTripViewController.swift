//
//  FinalizeTripViewController.swift
//  QualityTaxi
//
//  Created by Developer on 8/16/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class FinalizeTripViewController: UIViewController, UIGestureRecognizerDelegate {

    enum StarsRating: Int {
        case StarOne = 5
        case StarTwo = 10
        case StarThree = 15
        case StarFour = 20
        case StarFive = 30
    }
    
    @IBOutlet weak var directionsContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var rateContainerView: UIView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    var rating:StarsRating!{
        didSet{
            self.validateStarSelection()
        }
    }
    var currentTrip:QTTrip!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentTrip = QTUserManager.sharedInstance.getCurrentTrip()
        
        directionsContainerView.layer.borderWidth = 1
        directionsContainerView.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
        
        rateContainerView.layer.borderWidth = 1
        rateContainerView.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
        
        mainContainerView.layer.cornerRadius = 3
        mainContainerView.layer.borderWidth = 1
        mainContainerView.layer.borderColor = UIColor(hexString: "E3E3E3").CGColor
        mainContainerView.layer.shadowColor = UIColor(hexString: "717171").CGColor
        mainContainerView.layer.shadowOpacity = 0.5
        mainContainerView.layer.shadowOffset = CGSizeZero
        mainContainerView.layer.shadowRadius = 2
        
        let tapStarOne:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(starOnePressed))
        star1ImageView.addGestureRecognizer(tapStarOne)
        
        let tapStarTwo:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(starTwoPressed))
        star2ImageView.addGestureRecognizer(tapStarTwo)
        
        let tapStarThree:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(starThreePressed))
        star3ImageView.addGestureRecognizer(tapStarThree)
        
        let tapStarFour:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(starFourPressed))
        star4ImageView.addGestureRecognizer(tapStarFour)
        
        let tapStarFive:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(starFivePressed))
        star5ImageView.addGestureRecognizer(tapStarFive)
        
        self.deselectStars([star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView])
        self.selectStars([star1ImageView])
        
        originLabel.text = currentTrip.originStreet
        destinationLabel.text = currentTrip.destinationStreet
        rateLabel.text = currentTrip.rate! + " MX"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func finalizeButtonPressed(sender: AnyObject) {
        
    }
    
    func starOnePressed(){
        print("stare one pressed")
        rating = .StarOne
    }
    
    func starTwoPressed(){
        print("stare two pressed")
        rating = .StarTwo
    }
    
    func starThreePressed(){
        print("stare three pressed")
        rating = .StarThree
    }
    
    func starFourPressed(){
        print("stare four pressed")
        rating = .StarFour
    }
    
    func starFivePressed(){
        print("stare five pressed")
        rating = .StarFive
    }

    func selectStars(stars:[UIImageView]){
        for star in stars {
            star.image = UIImage(named: "star-icon-yellow")
        }
    }
    
    func deselectStars(stars:[UIImageView]){
        for star in stars {
            star.image = UIImage(named: "star-icon-gray")
        }
    }
    
    func validateStarSelection(){
        if rating.rawValue == StarsRating.StarFive.rawValue {
            self.selectStars([star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView])
        }else if rating.rawValue == StarsRating.StarFour.rawValue{
            self.selectStars([star1ImageView, star2ImageView, star3ImageView,star4ImageView])
            self.deselectStars([star5ImageView])
        }else if rating.rawValue == StarsRating.StarThree.rawValue{
            self.selectStars([star1ImageView, star2ImageView, star3ImageView])
            self.deselectStars([star5ImageView, star4ImageView])
        }else if rating.rawValue == StarsRating.StarTwo.rawValue{
            self.selectStars([star1ImageView, star2ImageView])
            self.deselectStars([star3ImageView, star4ImageView, star5ImageView])
        }else{
            self.selectStars([star1ImageView])
            self.deselectStars([star2ImageView, star3ImageView, star4ImageView, star5ImageView])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromFinalizeToStart" {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "onGoingTrip")
            NSUserDefaults.standardUserDefaults().synchronize()
            currentTrip.isActive = false
            QTUserManager.sharedInstance.updateTrip(currentTrip)
        }
    }
}
