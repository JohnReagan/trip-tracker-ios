//
//  ViewController.swift
//  TripTracker
//
//  Created by Joseph Songer on 10/20/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tripNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        tripNameLabel.text = textField.text
    }

    // MARK: Actions

    @IBAction func setDefaultLabelText(sender: UIButton) {
        tripNameLabel.text = "Default Text"
    }
    
}

