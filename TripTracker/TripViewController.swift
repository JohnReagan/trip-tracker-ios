//
//  TripViewController.swift
//  TripTracker
//
//  Created by Joseph Songer on 10/20/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class TripViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: Properties
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var locs: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var tracking = false
    
    
    
    var locationManager : CLLocationManager!
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        mapView.delegate = self
        checkValidTripName()
        locationManager = CLLocationManager()
        
        self.locationManager!.requestAlwaysAuthorization()
        
        self.locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Disable save button while editing
        saveButton.enabled = false
    }
    
    func checkValidTripName() {
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidTripName()
        navigationItem.title = textField.text
    }

    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //this method lets you configure a view controller before it's presented
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            
            createNewTrip(name)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0 {
            return
        }
        
        let newLocation = locations[0]
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
//        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        locs.append(newLocation.coordinate)
        var polyline = MKPolyline(coordinates: &locs, count: locs.count)
        mapView.addOverlay(polyline)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("The authorization status of location services is changed to: ", terminator: "")
        
        switch CLLocationManager.authorizationStatus(){
        case .AuthorizedAlways:
            print("Authorized")
        case .AuthorizedWhenInUse:
            print("Authorized when in use")
        case .Denied:
            print("Denied")
        case .NotDetermined:
            print("Not determined")
        case .Restricted:
            print("Restricted")
        }
    }
    
//    func createLocationManager(startImmediately startImmediately: Bool){
//        locationManager = CLLocationManager()
//        if let manager = locationManager{
//            print("Successfully created the location manager")
//            manager.delegate = self
//            if startImmediately{
//                manager.startUpdatingLocation()
//            }
//        }
//    }
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        /* Are location services available on this device? */
//        if CLLocationManager.locationServicesEnabled(){
//            
//            /* Do we have authorization to access location services? */
//            switch CLLocationManager.authorizationStatus(){
//            case .AuthorizedAlways:
//                /* Yes, always */
//                createLocationManager(startImmediately: true)
//            case .AuthorizedWhenInUse:
//                /* Yes, only when our app is in use */
//                createLocationManager(startImmediately: true)
//            case .Denied:
//                /* No */
//                displayAlertWithTitle("Not Determined",
//                    message: "Location services are not allowed for this app")
//            case .NotDetermined:
//                /* We don't know yet, we have to ask */
//                createLocationManager(startImmediately: false)
//                if let manager = self.locationManager{
//                    manager.requestWhenInUseAuthorization()
//                }
//            case .Restricted:
//                /* Restrictions have been applied, we have no access
//                to location services */
//                displayAlertWithTitle("Restricted",
//                    message: "Location services are not allowed for this app")
//            }
//            
//            
//        } else {
//            /* Location services are not enabled.
//            Take appropriate action: for instance, prompt the
//            user to enable the location services */
//            print("Location services are not enabled")
//        }
    }
    
    // MARK: Actions
    
//    @IBAction func
    /*@IBAction func startTracking(sender: UIButton) {
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction func stopTracking(sender: UIButton) {
        locationManager?.stopUpdatingLocation()
    }*/

    func createNewTrip(name: String) -> Bool {
        let newTrip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: managedObjectContext) as! TripTracker.Trip
        (newTrip.name) = name
        var didSave = false
        
        do {
            try managedObjectContext.save()
            didSave = true
        } catch let error as NSError {
            print("Failed to save the trip: Error = \(error)")
        }
        if (didSave) {
            var points = [Point]()
            for index in locs {
                let newPoint = NSEntityDescription.insertNewObjectForEntityForName("Point", inManagedObjectContext: managedObjectContext) as! TripTracker.Point
                newPoint.lat = index.latitude
                newPoint.long = index.longitude
                newPoint.trip = newTrip
                do {
                    try managedObjectContext.save()
                    points.append(newPoint)
                } catch let error as NSError {
                    print ("failed to save point: Error = \(error)")
                }
            }
            newTrip.points = NSSet(array: points)
        }
        
        return false
        
    }
    
    // MARK: mapView delegate methods
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return nil
    }
    
}

