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
    func tick(time: NSDate, location: CLLocation);
}

class DriveRecorder: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var recording = false
    var delegate: DriveRecorderDelegate?
    
    var drive: Drive!
    
    var timer: NSTimer!
    
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
        
        drive.driveData.startTime = NSDate()
    }
    
    func stopRecording() {
        recording = false
        
        locationManager.stopUpdatingLocation()
        drive.saveWithData()
        
        
        // need to save the recorded data...
    }
    
    // MARK: - Location manager delegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        for newLocation in locations {
            if newLocation.horizontalAccuracy < 20 {
                if locations.count > 0 {
                    drive.driveData.distance += newLocation.distanceFromLocation(drive.driveData.trackPoints.last)
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