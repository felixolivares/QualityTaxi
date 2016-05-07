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
        if indexPath.row == 0 {
            performSegueWithIdentifier("toPassenger", sender: self)
        }
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
