//
//  DriveDataPoint.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/21/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import Foundation
import CoreLocation

class DriveDataPoint {
    var timestamp: NSDate!
    var location: CLLocation!
    
    init(time: NSDate, location: CLLocation) {
        self.timestamp = time
        self.location = location
    }
    
//    var computedData
}