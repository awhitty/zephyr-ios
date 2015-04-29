
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
    
    func saveWithData() {
        driveDataStore.save()
        
        self.save()
//        driveDataStore.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
//            if succeeded {
//                self.saveInBackground()
//            } else {
//                println(error)
//            }
//        }
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