//
//  DriveRecorderBrain.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/21/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import Foundation
import CoreLocation

protocol DriveRecorderDelegate {
    // called every 100th of a second
    func tick(elapsedTime: NSDate, location: CLLocation, speed: Double);
}

class DriveRecorder: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var recording = false
    var delegate: DriveRecorderDelegate?
    
    var drive: Drive!
    
    var timer: NSTimer!
    
    // used for tick
    var speed: Double?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = CLActivityType.AutomotiveNavigation
        
        drive = Drive(className: "Drive")
        drive.trackName = "Test track"
        
    }
    
    // MARK: - Start and stop
    
    func startRecording() {
        recording = true
        
        locationManager.startUpdatingLocation()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
        
        drive.driveData.startTime = NSDate()
    }
    
    func stopRecording() {
        recording = false
        
        locationManager.stopUpdatingLocation()
        timer.invalidate()
        drive.saveWithData()
        
        
        // need to save the recorded data...
    }
    
    // MARK: - Tempo
    
    func tick() {
        if delegate != nil {
            var distance: Double?
            
            let currentTime = NSDate()
            let interval = currentTime.timeIntervalSinceDate(drive.driveData.startTime)
            let timerDate = NSDate(timeIntervalSince1970: interval)
            
            var convertedSpeed: Double!
            if speed != nil {
                // speed to mph
                convertedSpeed = speed! / 1609.344 * 3600
            } else {
                convertedSpeed = 0.0
            }
            
            delegate?.tick(timerDate, location: locationManager.location, speed: convertedSpeed)
        }
    }
    
    // MARK: - Location manager delegate
    
    // Review: Do we still need this?
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        for newLocation in locations {
            if newLocation.horizontalAccuracy < 20 {
                if drive.driveData.trackPoints.count > 0 {
                    let previousLocation = drive.driveData.trackPoints.last!
                    
                    let tempDistance = newLocation.distanceFromLocation(previousLocation)
                    drive.driveData.distance += tempDistance
                    
                    // speed is in meters/second?
                    speed = tempDistance / newLocation.timestamp!.timeIntervalSinceDate(previousLocation.timestamp)
                }
                
                drive.driveData.trackPoints.append(newLocation as! CLLocation)
            }
        }
    }
    
    func checkLocationAuthorization() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            return true
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
            return true
        case .Denied:
            return false
        default:
            break
        }
        
        return false
    }
}