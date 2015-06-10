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
    
    var distance: Double {
        var d: Double = 0.0
        if (trackPoints.count >  1) {
            for i in 0...(trackPoints.count - 2) {
                d += trackPoints[i].location.distanceFromLocation(trackPoints[i + 1].location)
            }
        }
        
        return d
    }
    
    var driveTime: NSTimeInterval {
        return endTime.timeIntervalSinceDate(startTime)
    }
    
    // each speed method returns value in meters per second
    var maxSpeed: Double {
        return trackPoints.map({ $0.speed }).reduce(0, combine: max)
    }
    
    var averageSpeed: Double {
        return trackPoints.map({ $0.speed }).reduce(0.0, combine: +) / Double(trackPoints.count)
    }
    
    var lastRecordedSpeed: Double {
        return trackPoints.last?.speed ?? 0.0
    }
    
    
    var trackPoints = [DriveDataPoint]()
    // todo: what else?
    
    
    // MARK: - NSCoding bits
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(trackPoints, forKey: "points")
        aCoder.encodeObject(startTime, forKey: "start")
        aCoder.encodeObject(endTime, forKey: "end")
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.trackPoints = aDecoder.decodeObjectForKey("points") as! [DriveDataPoint]
        self.startTime   = aDecoder.decodeObjectForKey("start") as! NSDate
        self.endTime     = aDecoder.decodeObjectForKey("end") as! NSDate
    }
    
    func addPoint(point: CLLocation) {
        let timestamp = point.timestamp
        var speed = 0.0
        var acceleration = 0.0
        if let lastPoint = trackPoints.last {
            let distanceFromLastPoint = point.distanceFromLocation(lastPoint.location)
            let timeSinceLastPoint = point.timestamp.timeIntervalSinceDate(lastPoint.timestamp)
            speed = distanceFromLastPoint / timeSinceLastPoint
            acceleration = (speed - lastPoint.speed) / timeSinceLastPoint
        }
        
        let course = point.course
        
        let trackPoint = DriveDataPoint(time: timestamp, location: point, speed: speed, acceleration: acceleration, course: course)
        
        
        
        trackPoints.append(trackPoint)
    }
}

extension Double {
    var mph: Double { get { return self * 2.23694 } }
    var miles:  Double { get { return self * 0.000621371 } }
    var g: Double { get { return self * 0.101971621 } }
}