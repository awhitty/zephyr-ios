
//
//  Drive.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/21/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import Foundation
import CoreLocation

class Drive: PFObject, PFSubclassing {
    
    @NSManaged var user: String
    @NSManaged var trackName: String
    @NSManaged var carDescription: String
    @NSManaged var driveDataPrimitive: PFFile
    
    var driveData: DriveData? {
        get {
            return NSKeyedUnarchiver.unarchiveObjectWithData(driveDataPrimitive.getData()!) as? DriveData
        }
        
        set {
            // archive the data and save it to the pffile...
        }
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Drive"
    }
}