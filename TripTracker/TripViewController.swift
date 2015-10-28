//
//  TripViewController.swift
//  TripTracker
//
//  Created by Joseph Songer on 10/20/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import UIKit
import MapKit


class TripViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        checkValidTripName()
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
            let rating = 0
            let x = Float80(0)
            let y = Float80(0)
            trip = Trip(name: name, rating: rating, x: x, y: y)
        }
    }
    
    // MARK: Actions

    
    
}

