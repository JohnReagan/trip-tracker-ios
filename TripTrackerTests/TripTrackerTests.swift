//
//  TripTrackerTests.swift
//  TripTrackerTests
//
//  Created by Joseph Songer on 10/20/15.
//  Copyright © 2015 UVa. All rights reserved.
//
import UIKit
import XCTest
@testable import TripTracker

class TripTrackerTests: XCTestCase {
    
    
    // MARK: TripTracker Tests
    
    func testTripInitialization() {
        //Success case
        let potentialTrip = Trip(name: "Newest Trip", rating: 0, x: 0, y: 0)
        XCTAssertNotNil(potentialTrip)
        
        //Failure cases
        let noName = Trip(name: "", rating: 0, x: 0, y: 0)
        XCTAssertNil(noName, "Empty name invalid")
        
        let badRate = Trip(name: "New Trip", rating: -3, x: 0, y: 0)
        XCTAssertNil(badRate, "Negative rating is invalid")
    }
}
