//
//  Trip.swift
//  TripTracker
//
//  Created by Joseph Songer on 10/28/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import UIKit

class Trip {
    
    // MARK: Properties
    
    
    var name: String
    
    var rating: Int
    
    var x: Float80
    
    var y: Float80
    
    // MARK: Initialization
    
    
    init?(name: String, rating: Int, x: Float80, y: Float80) {
        self.name = name
        self.rating = rating
        self.x = x
        self.y = y
        
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
}
