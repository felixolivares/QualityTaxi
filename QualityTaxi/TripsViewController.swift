//
//  TripsViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/29/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let kTripCellIdentifier = "TripTableViewCellIdentifier"
    var allTrips:[ClientTrip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tripTableViewCell = UINib(nibName: "TripTableViewCell", bundle: nil)
        tableView.registerNib(tripTableViewCell, forCellReuseIdentifier: kTripCellIdentifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor(hexString: "E7EBEC")
        
        let trip1 = ClientTrip()
        trip1.from = "Canario 51 Col. Nuevo Progreso"
        trip1.to = "Delfin 110, Lopez Mateos"
        trip1.rate = "35"
        trip1.distance = 12.0
        allTrips.append(trip1)
        
        let trip2 = ClientTrip()
        trip2.from = "Juarez 21 Col. Centro"
        trip2.to = "Paraiso 36 Fracc. Villas del Paraise"
        trip2.rate = "40"
        trip2.distance = 8.0
        allTrips.append(trip2)

        let trip3 = ClientTrip()
        trip3.from = "Iturbide 34, Menchaca"
        trip3.to = "Madero 453 Col Centro"
        trip3.rate = "25"
        trip3.distance = 3.0
        allTrips.append(trip3)

        let trip4 = ClientTrip()
        trip4.from = "Roma 32 Col. Chapalita"
        trip4.to = "Girasol 64 Jardines"
        trip4.rate = "30"
        trip4.distance = 5.0
        allTrips.append(trip4)        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func sortingPressed(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Selecciona el tipo de orden por:", preferredStyle: .ActionSheet)
        let distanceAction = UIAlertAction(title: "Distancia", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Distance pressed")
//            self.allTrips.sortInPlace{$0.distance.compare($1.distance) == .OrderedDescending}
            self.allTrips.sortInPlace({$0.distance > $1.distance})
            self.tableView.reloadData()
        })
        
        let rateAction = UIAlertAction(title: "Precio", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Rate pressed")
            self.allTrips.sortInPlace{$0.rate.compare($1.rate) == .OrderedDescending}
            self.tableView.reloadData()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
