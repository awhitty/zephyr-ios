
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
    @NSManaged var driveDataStore: PFFile
    var driveDataPrimitive: DriveData?
    
    var driveData: DriveData {
        get {
            if driveDataPrimitive == nil {
                if driveDataStore.getData() != nil {
                    driveDataPrimitive = NSKeyedUnarchiver.unarchiveObjectWithData(driveDataStore.getData()!) as? DriveData
                } else {
                    driveDataPrimitive = DriveData()
                }
            }
            
            return driveDataPrimitive!
        }
        
        set {
            driveDataPrimitive = newValue
            driveDataStore = PFFile(data: NSKeyedArchiver.archivedDataWithRootObject(driveData))
        }
    }
    
    func saveWithData(block: PFBooleanResultBlock?) {
        let file = PFFile(data: NSKeyedArchiver.archivedDataWithRootObject(driveData))
        
        file.saveInBackgroundWithBlock { (completed, error) -> Void in
            if completed {
                self.driveDataStore = file
                self.saveInBackgroundWithBlock(block)
            }
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