//
//  TripsViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/29/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var subBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let kTripCellIdentifier = "TripTableViewCellIdentifier"
    var allTrips:[ClientTrip] = []
    var tripTimer: NSTimer!
    var secondTimer: NSTimer!
    var sorting = ""
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tripTableViewCell = UINib(nibName: "TripTableViewCell", bundle: nil)
        tableView.registerNib(tripTableViewCell, forCellReuseIdentifier: kTripCellIdentifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor(hexString: "E7EBEC")
        
//        subBar.layer.borderColor = UIColor(hexString: "8A6108").CGColor
//        subBar.layer.borderWidth = 0.5
        
        let trip1 = ClientTrip()
        trip1.from = "Canario 51 Col. Nuevo Progreso"
        trip1.to = "Delfin 110, Lopez Mateos"
        trip1.rate = "35"
        trip1.distance = 12.0
        trip1.id = "234"
        trip1.distanceToUser = 3.0
        trip1.cash = "35"
        trip1.name = "Juan"
        allTrips.append(trip1)
        
        let trip2 = ClientTrip()
        trip2.from = "Juarez 21 Col. Centro"
        trip2.to = "Paraiso 36 Fracc. Villas del Paraise"
        trip2.rate = "40"
        trip2.distance = 8.0
        trip2.id = "21"
        trip2.distanceToUser = 3.0
        trip2.cash = "35"
        trip2.name = "Pedro"
        allTrips.append(trip2)

        let trip3 = ClientTrip()
        trip3.from = "Iturbide 34, Menchaca"
        trip3.to = "Madero 453 Col Centro"
        trip3.rate = "25"
        trip3.distance = 3.0
        trip3.id = "46"
        trip3.distanceToUser = 3.0
        trip3.cash = "35"
        trip3.name = "Luis"
        allTrips.append(trip3)

        let trip4 = ClientTrip()
        trip4.from = "Roma 32 Col. Chapalita"
        trip4.to = "Girasol 64 Jardines"
        trip4.rate = "30"
        trip4.distance = 5.0
        trip4.id = "1234"
        trip4.distanceToUser = 3.0
        trip4.cash = "35"
        trip4.name = "Paco"
        allTrips.append(trip4)        
        
        //Sorted results by Distance at the beginning
        sorting = "distance"
        self.allTrips.sortInPlace({$0.distance > $1.distance})
        self.tableView.reloadData()
        
        tripTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(addNewTrip), userInfo: nil, repeats: false)
        secondTimer = NSTimer.scheduledTimerWithTimeInterval(14, target: self, selector: #selector(addSecondTrip), userInfo: nil, repeats: false)
        
        
    }

    func addNewTrip(){
        tripTimer.invalidate()
        let trip1 = ClientTrip()
        trip1.from = "Niños Heroes 37, Moctezuma"
        trip1.to = "Obregon 145, Jazmines"
        trip1.rate = "35"
        trip1.distance = 7.0
        trip1.id = "668"
        allTrips.append(trip1)
        
        switch sorting {
        case "distance":
            self.allTrips.sortInPlace({$0.distance > $1.distance})
            let newIndex = allTrips.indexOf({$0.id == "668"})
            print("new item index = \(newIndex)")
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: newIndex!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
            self.tableView.endUpdates()
            
        case "rate":
            self.allTrips.sortInPlace{$0.rate.compare($1.rate) == .OrderedDescending}
            let newIndex = allTrips.indexOf({$0.id == "668"})
            print("new item index = \(newIndex)")
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: newIndex!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
            self.tableView.endUpdates()
        default:
            print("default")
        }
        
    }
    
    func addSecondTrip(){
        secondTimer.invalidate()
        let trip1 = ClientTrip()
        trip1.from = "Rio Bravo 134, Col. Mololoa"
        trip1.to = "Uruguay 459, Col. Magisteral"
        trip1.rate = "40"
        trip1.distance = 11.0
        trip1.id = "334"
        allTrips.append(trip1)
        
        switch sorting {
        case "distance":
            self.allTrips.sortInPlace({$0.distance > $1.distance})
            let newIndex = allTrips.indexOf({$0.id == "334"})
            print("new item index = \(newIndex)")
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: newIndex!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
            self.tableView.endUpdates()
            
        case "rate":
            self.allTrips.sortInPlace{$0.rate.compare($1.rate) == .OrderedDescending}
            let newIndex = allTrips.indexOf({$0.id == "334"})
            print("new item index = \(newIndex)")
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: newIndex!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
            self.tableView.endUpdates()
        default:
            print("default")
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
        return allTrips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TripTableViewCell = tableView.dequeueReusableCellWithIdentifier(kTripCellIdentifier) as! TripTableViewCell
        cell.fromLabel.text = allTrips[indexPath.row].from
        cell.toLabel.text = allTrips[indexPath.row].to
        cell.rateLabel.text = "$ " + allTrips[indexPath.row].rate
        cell.distanceLabel.text = String(allTrips[indexPath.row].distance) + " Km"
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toSelectedRequest", sender: allTrips[indexPath.row])
    }
    
    @IBAction func sortingPressed(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Selecciona el tipo de orden por:", preferredStyle: .ActionSheet)
        let distanceAction = UIAlertAction(title: "Distancia", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Distance pressed")
//            self.allTrips.sortInPlace{$0.distance.compare($1.distance) == .OrderedDescending}
            self.allTrips.sortInPlace({$0.distance > $1.distance})
            self.tableView.reloadData()
            self.sorting = "distance"
        })
        
        let rateAction = UIAlertAction(title: "Precio", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Rate pressed")
            self.allTrips.sortInPlace{$0.rate.compare($1.rate) == .OrderedDescending}
            self.tableView.reloadData()
            self.sorting = "rate"
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })

        optionMenu.addAction(distanceAction)
        optionMenu.addAction(rateAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc:RequestSelectedViewController = segue.destinationViewController as! RequestSelectedViewController
        vc.tripSelected = sender as! ClientTrip
    }
    

}
