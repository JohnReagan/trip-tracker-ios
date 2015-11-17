//
//  TripTableViewController.swift
//  TripTracker
//
//  Created by Joseph Songer on 10/28/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import UIKit
import CoreData

class TripTableViewController: UITableViewController {
    
    // MARK: Properties
    var trips = [NSManagedObject]()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TripTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TripTableViewCell
        
        // fetches appropriate trip for data source layout
        let trip = trips[indexPath.row]
        let myLabel = trip.valueForKey("name")  as! String
        cell.nameLabel!.text = myLabel
        cell.thumbnail!.image = UIImage(data: trip.valueForKey("picture") as! NSData)

        return cell
    }

    
    // MARK: - Navigation

    // pass trip from clicked cell to next scene
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTrip" {
            let navVC = segue.destinationViewController as! UINavigationController
            if let destination = navVC.viewControllers.first as? ShowTripController {
                if let tripIndex = tableView.indexPathForSelectedRow?.row {
                    destination.trip = trips[tripIndex] as! Trip
                }
            }
        }
    }
    
    
    @IBAction func unwindToTripList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TripViewController {
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        
        // get trip list from core data and add to table view
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            trips = results as! [NSManagedObject]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
