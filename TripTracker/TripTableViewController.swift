//
//  TripTableViewController.swift
//  TripTracker
//
//  Created by Joseph Songer on 10/28/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import UIKit

class TripTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var trips = [Trip]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // load sample data
        
        loadSampleTrips()
    }
    
    func loadSampleTrips() {
        let trip1 = Trip(name: "A walkabout", rating: 5, x: 0, y: 0)!
        
        let trip2 = Trip(name: "There and back again", rating: 4, x: 0, y: 0)!
        
        let trip3 = Trip(name: "Test", rating: 1, x: 0, y: 0)!
        
        trips += [trip1, trip2, trip3]
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

        cell.nameLabel.text = trip.name
        cell.ratingLabel.text = String(trip.rating)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToTripList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TripViewController, trip = sourceViewController.trip {
            //add new trip
            let newIndexPath = NSIndexPath(forRow: trips.count, inSection: 0)
            
            trips.append(trip)
            
            // inserted row slides in at bottom
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
    }

}
