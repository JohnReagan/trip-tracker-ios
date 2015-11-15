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

class ShowTripController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    var locationManager : CLLocationManager!
    var trip: Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = trip.name
    }
}