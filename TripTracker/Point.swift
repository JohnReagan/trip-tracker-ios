//
//  Point.swift
//  TripTracker
//
//  Created by Joseph Songer on 11/1/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import Foundation
import UIKit
import CoreData


@objc(Point) class Point: NSManagedObject {
    
    // MARK: Properties
    @NSManaged var lat: Double
    @NSManaged var long: Double
    @NSManaged var trip_id: Int
}