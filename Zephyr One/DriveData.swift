//
//  DriveData.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/21/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import Foundation
import CoreLocation

class DriveData: NSObject, NSCoding {
    var startTime: NSDate!
    var endTime: NSDate!
    
    var distance = 0.0
    
    var trackPoints = [CLLocation]()
    // todo: what else?
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(trackPoints, forKey: "points")
        aCoder.encodeObject(startTime, forKey: "start")
        aCoder.encodeObject(endTime, forKey: "end")
        
        aCoder.encodeDouble(distance, forKey: "distance")
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.trackPoints = aDecoder.decodeObjectForKey("points") as! [CLLocation]
        self.startTime   = aDecoder.decodeObjectForKey("start") as! NSDate
        self.endTime     = aDecoder.decodeObjectForKey("end") as! NSDate
        
        self.distance    = aDecoder.decodeDoubleForKey("distance")
    }
}