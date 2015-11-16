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
    
    //var trips = [Trip]()
    var trips = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // load sample data
        
        loadSampleTrips()
    }
    
    func loadSampleTrips() {
        
    }

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
        
        // fetches appropriate meal for data source layout
        let trip = trips[indexPath.row]
//        do {
//            let annos = try trip.valueForKey("annotations")
//            annCount = (annos as! NSSet).count
//        } catch let exception as NSException {
//            print("No annotations for trip")
//        }
        let count = (trip.valueForKey("points") as! NSSet).count
//        let annCount = (trip.valueForKey("annotations") as! NSSet).count
        //let count = trip.points.count as! String
        let myLabel = trip.valueForKey("name")  as! String + ", count: " + String(count)

        cell.nameLabel!.text = myLabel

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTrip" {
            if let destination = segue.destinationViewController as? ShowTripController {
                if let tripIndex = tableView.indexPathForSelectedRow?.row {
                    destination.trip = trips[tripIndex] as! Trip
                }
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func unwindToTripList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TripViewController {
            //add new trip
//            let newIndexPath = NSIndexPath(forRow: trips.count, inSection: 0)
            
//            trips.append(trip)
//            self.saveName(
            
            // inserted row slides in at bottom
//            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            trips = results as! [NSManagedObject]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        } 
        
//        let newIndexPath = NSIndexPath(forRow: trips.count, inSection: 0)
//        
//
//        
////         inserted row slides in at bottom
//                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)

    }

}
