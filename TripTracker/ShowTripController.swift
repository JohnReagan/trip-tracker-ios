//
//  ShowTripController.swift
//  TripTracker
//
//  Created by Joseph Songer on 11/15/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class ShowTripController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    
    var locationManager : CLLocationManager!
    var trip: Trip!
    var annotation: MKPointAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        imageView.image = UIImage(data: trip.picture)
        label.text = trip.name
        
        // draw polyline of trip
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for point in trip.points {
            let newPoint = point as! Point
            let temp = CLLocationCoordinate2D(latitude: newPoint.lat, longitude: newPoint.long)
            points.append(temp)
        }
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        mapView.addOverlay(polyline)
        
        locationManager = CLLocationManager()
        
        self.locationManager!.requestAlwaysAuthorization()
        
        self.locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0 {
            return
        }
        
        // move pin as user location updates
        let newLocation = locations[0]
        mapView.removeAnnotation(annotation)
        annotation.coordinate = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return nil
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}