//
//  Picture.swift
//  TripTracker
//
//  Created by Joseph Songer on 11/16/15.
//  Copyright © 2015 UVa. All rights reserved.
//

import Foundation
import UIKit
import CoreData


@objc(Picture) class Picture: NSManagedObject {
    
    // MARK: Properties
    @NSManaged var image: NSData
    
}