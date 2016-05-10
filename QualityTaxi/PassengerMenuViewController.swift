//
//  PassengerMenuViewController.swift
//  QualityTaxi
//
//  Created by Developer on 5/6/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class PassengerMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuTableView: UITableView!
    
    let titles:[String] = ["Inicio", "Mis Viajes", "Cerrar Sesión"]
    let kMenuCellIdentifier = "MenuCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let menuTableViewCell = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.registerNib(menuTableViewCell, forCellReuseIdentifier: kMenuCellIdentifier)
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        menuTableView.backgroundColor = UIColor(hexString: "2C2A2A")
        
        let cell = menuTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        cell?.selected = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = tableView.dequeueReusableCellWithIdentifier(kMenuCellIdentifier) as! MenuTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            performSegueWithIdentifier("toPassenger", sender: self)
        case 1:
            performSegueWithIdentifier("toMyTrips", sender: self)
        case 2:
            self.logout()
        default:
            print("Menu option invalid")
        }
        let cell:MenuTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MenuTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        cell.titleLabel.textColor = UIColor(hexString: "2C2A2A")
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:MenuTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MenuTableViewCell
        cell.titleLabel.textColor = UIColor(hexString: "ffffff")
    }
    
    func logout(){
        performSegueWithIdentifier("unwindToLogin", sender: self)
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
