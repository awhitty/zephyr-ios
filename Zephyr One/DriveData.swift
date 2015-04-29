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
        
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.trackPoints = aDecoder.decodeObjectForKey("points") as! [CLLocation]
    }
}