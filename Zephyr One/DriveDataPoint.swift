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
    var acceleration: Double!
    
    var course: CLLocationDirection!
    
    init(time: NSDate, location: CLLocation, speed: Double, acceleration: Double, course: CLLocationDirection) {
        self.timestamp = time
        self.location = location
        self.speed = speed
        self.acceleration = acceleration
        self.course = course
    }
    
    // MARK: - NSCoding bits
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(timestamp, forKey: "timestamp")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(speed, forKey: "speed")
        aCoder.encodeObject(acceleration, forKey: "acceleration")
        aCoder.encodeObject(course, forKey: "course")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.timestamp = aDecoder.decodeObjectForKey("timestamp") as! NSDate
        self.location  = aDecoder.decodeObjectForKey("location") as! CLLocation
        self.speed     = aDecoder.decodeObjectForKey("speed") as! Double
        self.acceleration = aDecoder.decodeObjectForKey("acceleration") as! Double
        self.course       = aDecoder.decodeObjectForKey("course") as! CLLocationDirection
    }

}