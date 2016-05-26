//
//  MyTripsViewController.swift
//  QualityTaxi
//
//  Created by Developer on 5/10/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class MyTripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var secondTableView: UITableView!
    @IBOutlet weak var secondIconLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondIconHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstIconLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstIconHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondIconLabel: UILabel!
    @IBOutlet weak var secondIcon: UILabel!
    @IBOutlet weak var firstIconLabel: UILabel!
    @IBOutlet weak var firstIcon: UILabel!
    @IBOutlet weak var secondTab: UIView!
    @IBOutlet weak var firstTab: UIView!
    
    var allTrips:[QualityTrip]!
    var currentTrips:[QualityTrip] = []
    var pastTrips:[QualityTrip] = []
    let kTripCellIdentifier = "TripCellIdentifier"
    var currentTrip:QualityTrip!    
    let defaults = NSUserDefaults.standardUserDefaults()
    var isFirstTabActive:Bool = false
    var isSecondTabActive:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let tripTableViewCell = UINib(nibName: "MyTripsTableViewCell", bundle: nil)
        let tripHistoryTableViewCell = UINib(nibName: "MyTripsTableViewCell", bundle: nil)
        tableView.registerNib(tripTableViewCell, forCellReuseIdentifier: kTripCellIdentifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor(hexString: "E7EBEC")
        secondTableView.registerNib(tripHistoryTableViewCell, forCellReuseIdentifier: kTripCellIdentifier)
        secondTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        secondTableView.backgroundColor = UIColor(hexString: "E7EBEC")
        
        allTrips = QualityTrip.MR_findAllSortedBy("createdAt", ascending: true) as! [QualityTrip]
        print("all trips count \(allTrips.count)")
        for trip in allTrips {
            let isActive:Bool = trip.isActive as! Bool
            if isActive == true{
                self.currentTrips.append(trip)
            }else{
                self.pastTrips.append(trip)
            }
        }
        
        //Tab bar setup
        let tapFirst = UITapGestureRecognizer(target: self, action: #selector(pressedFirstTab))
        tapFirst.delegate = self
        firstTab.addGestureRecognizer(tapFirst)
        
        let tapSecond = UITapGestureRecognizer(target: self, action: #selector(pressedSecondTab))
        tapSecond.delegate = self
        secondTab.addGestureRecognizer(tapSecond)
        
        self.firstFadeIn()
        
        firstIcon.font = UIFont.fontAwesomeOfSize(14)
        firstIcon.text = String.fontAwesomeIconWithCode("fa-taxi")
        firstIcon.textColor = UIColor(hexString: "F7F7F7")
        firstIconLabel.alpha = 1
        
        secondIcon.font = UIFont.fontAwesomeOfSize(14)
        secondIcon.text = String.fontAwesomeIconWithCode("fa-clock-o")
        secondIcon.textColor = UIColor(hexString: "F7F7F7")
        secondIconLabel.alpha = 0
        
        
//        self.firstIconLabel.alpha = 1
//        self.firstIcon.textColor = UIColor(hexString: "F7F7F7")
//        
//        //Information tab is always hidden at the begining
//        secondIconLabel.alpha = 0
//        secondIcon.textColor = UIColor(hexString: "7F7F7F")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRowAtIndexPath(index, animated: false)
        }
        if let index = self.secondTableView.indexPathForSelectedRow {
            self.secondTableView.deselectRowAtIndexPath(index, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return currentTrips.count
        }else{
            return pastTrips.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell:MyTripsTableViewCell = tableView.dequeueReusableCellWithIdentifier(kTripCellIdentifier) as! MyTripsTableViewCell
            let eachTrip:QualityTrip = currentTrips[indexPath.row]
            print("each trip = \(eachTrip)")
            if let tripImage = eachTrip.tripImage{
                cell.tripImageView.image = UIImage(data: tripImage)
            }
            
            //Get date from the record.
            let dateInMili:Double = Double(eachTrip.createdAt!)!
            let dateEpoch:NSTimeInterval = dateInMili/1000
            let date = NSDate(timeIntervalSince1970: dateEpoch)
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = .ShortStyle
            let dateString = formatter.stringFromDate(date)
            
            cell.dateLabel.text = dateString
            cell.kindLabel.text = eachTrip.carKind! + " " + eachTrip.carColor! + " " + eachTrip.carPlates!
            cell.rateLabel.text = eachTrip.rate!
            cell.selectionStyle = UITableViewCellSelectionStyle.Blue
            
            return cell
        }else{
            let cell:MyTripsTableViewCell = tableView.dequeueReusableCellWithIdentifier(kTripCellIdentifier) as! MyTripsTableViewCell
            let eachTrip:QualityTrip = pastTrips[indexPath.row]
            print("each trip = \(eachTrip)")
            
            switch indexPath.row {
            case 0:
                cell.tripImageView.image = UIImage(named: "map1")
            case 1:
                cell.tripImageView.image = UIImage(named: "map2")
            case 2:
                cell.tripImageView.image = UIImage(named: "map3")
            default:
                cell.tripImageView.image = nil
            }
            
            //Get date from the record.
            let dateInMili:Double = Double(eachTrip.createdAt!)!
            let dateEpoch:NSTimeInterval = dateInMili/1000
            let date = NSDate(timeIntervalSince1970: dateEpoch)
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = .ShortStyle
            let dateString = formatter.stringFromDate(date)
            
            cell.dateLabel.text = dateString
            cell.kindLabel.text = eachTrip.carKind! + " " + eachTrip.carColor! + " " + eachTrip.carPlates!
            cell.rateLabel.text = eachTrip.rate!
            cell.selectionStyle = UITableViewCellSelectionStyle.Blue
            
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let eachTrip:QualityTrip = allTrips[indexPath.row]
        self.performSegueWithIdentifier("toFindTaxi", sender: eachTrip.createdAt)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc:FindTaxiViewController = segue.destinationViewController as! FindTaxiViewController
        vc.currentTripTime = sender as! String
        vc.fromMyTrips = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pressedFirstTab(){
        if !isFirstTabActive {
            //Map fade in
            self.firstFadeIn()
            
            //Information fade out
            self.secondFadeOut()
            
            UIView.animateWithDuration(0.2, animations: {
//                self.infoContainerView.alpha = 0
//                self.viewMap.alpha = 1
                self.secondTableView.alpha = 0
                self.tableView.alpha = 1
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.1, animations: {
                        
                    })
            })
        }
    }
    
    func pressedSecondTab(){
        if !isSecondTabActive{
            //Information fade out
            self.secondFadeIn()
            
            //Map fade in
            self.firstFadeOut()
            
            UIView.animateWithDuration(0.2, animations: {
//                self.viewMap.alpha = 0
//                self.infoContainerView.alpha = 1
                self.tableView.alpha = 0
                self.secondTableView.alpha = 1
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.1, animations: {
                        
                    })
            })
        }
    }
    
    func firstFadeIn(){
        firstIconHorizontalConstraint.constant -= 4
        firstIconLabelBottomConstraint.constant += 7
        UIView.animateWithDuration(0.2) {
            self.firstIconLabel.alpha = 1
            self.firstIcon.textColor = UIColor(hexString: "F7F7F7")
            self.view.layoutIfNeeded()
        }
        isFirstTabActive = true
    }
    
    func firstFadeOut(){
        firstIconHorizontalConstraint.constant += 4
        firstIconLabelBottomConstraint.constant -= 7
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
            self.firstIconLabel.alpha = 0
            self.firstIcon.textColor = UIColor(hexString: "7F7F7F")
        }
        isFirstTabActive = false
    }
    
    func secondFadeOut(){
        secondIconHorizontalConstraint.constant += 4
        secondIconLabelBottomConstraint.constant -= 7
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
            self.secondIconLabel.alpha = 0
            self.secondIcon.textColor = UIColor(hexString: "7F7F7F")
        }
        isSecondTabActive = false
    }
    
    func secondFadeIn(){
        secondIconHorizontalConstraint.constant -= 4
        secondIconLabelBottomConstraint.constant += 7
        UIView.animateWithDuration(0.2) {
            self.secondIconLabel.alpha = 1
            self.secondIcon.textColor = UIColor(hexString: "F7F7F7")
            self.view.layoutIfNeeded()
        }
        isSecondTabActive = true
    }

}
