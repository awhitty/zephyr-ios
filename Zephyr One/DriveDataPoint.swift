//
//  DriveDataPoint.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/21/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import Foundation
import CoreLocation

class DriveDataPoint: NSObject, NSCoding {
    var timestamp: NSDate!
    var location: CLLocation!
    var speed: Double!
    
    init(time: NSDate, location: CLLocation, speed: Double) {
        self.timestamp = time
        self.location = location
        self.speed = speed
    }
    
    // MARK: - NSCoding bits
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(timestamp, forKey: "timestamp")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(speed, forKey: "speed")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.timestamp = aDecoder.decodeObjectForKey("timestamp") as! NSDate
        self.location  = aDecoder.decodeObjectForKey("location") as! CLLocation
        self.speed     = aDecoder.decodeObjectForKey("speed") as! Double
    }

}