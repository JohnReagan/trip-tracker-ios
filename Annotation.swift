//
//  Annotation.swift
//  TripTracker
//
//  Created by Joseph Songer on 11/16/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import Foundation
import UIKit
import CoreData


@objc(Annotation) class Annotation: NSManagedObject {
    
    // MARK: Properties
    @NSManaged var lat: Double
    @NSManaged var long: Double
    @NSManaged var title: String
    @NSManaged var subtitle: String
    @NSManaged var picture: NSData
    @NSManaged var trip: Trip 
}