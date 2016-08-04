//
//  PassengerMenuViewController.swift
//  QualityTaxi
//
//  Created by Developer on 5/6/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit
import FontAwesome_swift

class PassengerMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuTableView: UITableView!
    
    let titles:[String] = ["Inicio", "Mis Viajes", "Mi Cuenta", "Acerca de Quality", "Ajustes", "Cerrar Sesión"]
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
        
        switch indexPath.row{
        case 0:
            cell.iconLabel.text = String.fontAwesomeIconWithCode("fa-taxi")
        case 1:
            cell.iconLabel.text = String.fontAwesomeIconWithCode("fa-road")
        case 2:
            cell.iconLabel.text = String.fontAwesomeIconWithCode("fa-user")
        case 3:
            cell.iconLabel.text = String.fontAwesomeIconWithCode("fa-info-circle")
        case 4:
            cell.iconLabel.text = String.fontAwesomeIconWithCode("fa-sliders")
        default:
            cell.iconLabel.text = String.fontAwesomeIconWithCode("fa-sign-out")
        }
        cell.iconLabel.font = UIFont.fontAwesomeOfSize(17)
        cell.iconLabel.textColor = UIColor(hexString: "F7F7F7")
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
            performSegueWithIdentifier("toMyProfile", sender: self)
        case 3:
            performSegueWithIdentifier("toAbout", sender: self)
        case 4:
            performSegueWithIdentifier("toSettingsPassenger", sender: self)
        case titles.count - 1:
            self.logout()
        default:
            print("Menu option invalid")
        }
        let cell:MenuTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MenuTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        cell.titleLabel.textColor = UIColor(hexString: "2C2A2A")
        cell.iconLabel.textColor = UIColor(hexString: "2C2A2A")
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:MenuTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MenuTableViewCell
        cell.titleLabel.textColor = UIColor(hexString: "ffffff")
        cell.iconLabel.textColor = UIColor(hexString: "F7F7F7")
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
