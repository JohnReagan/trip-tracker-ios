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

class TripViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Properties
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var locs: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var tracking = false
    var isImage = false
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
        saveButton.enabled = !text.isEmpty && isImage
        
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
    
    // save trip and segue to table view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            
            createNewTrip(name)
        }
    }
    
    // MARK: Location Manager Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0 {
            return
        }
        
        // add new point to polyline and render
        let newLocation = locations[0]
        locs.append(newLocation.coordinate)
        let polyline = MKPolyline(coordinates: &locs, count: locs.count)
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
    
    
    // Mark: Image Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        isImage = true
        checkValidTripName()
    }
    
    func prepareImageForSaving(image: UIImage) -> NSData {
        // scale image
        let thumbnail = self.scale(image: image, toSize: self.view.frame.size)
        
        guard let thumbnailData  = UIImageJPEGRepresentation(thumbnail, 0.7) else {
            // handle failed conversion
            print("jpg error")
            return NSData()
        }
        return thumbnailData
    }
    
    func scale(image image:UIImage, toSize newSize:CGSize) -> UIImage {
        
        // make sure the new size has the correct aspect ratio
        let aspectFill = resizeFill(image.size, toSize: newSize)
        
        UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, aspectFill.width, aspectFill.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizeFill(fromSize: CGSize, toSize: CGSize) -> CGSize {
        
        let aspectOne = fromSize.height / fromSize.width
        let aspectTwo = toSize.height / toSize.width
        
        let scale : CGFloat
        
        if aspectOne < aspectTwo {
            scale = fromSize.height / toSize.height
        } else {
            scale = fromSize.width / toSize.width
        }
        
        let newHeight = fromSize.height / scale
        let newWidth = fromSize.width / scale
        return CGSize(width: newWidth, height: newHeight)
        
    }
    

    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    // MARK: Actions
    @IBAction func takePicture(sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // saves trip to database
    func createNewTrip(name: String) -> Bool {
        let newTrip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: managedObjectContext) as! TripTracker.Trip
        (newTrip.name) = name
        newTrip.picture = prepareImageForSaving(imageView.image!)
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
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return nil
    }
    
}

