//
//  FeedDriveViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 5/8/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit
import MapKit

class FeedDriveViewController: UIViewController, RETableViewManagerDelegate {
    
    var drive: Drive!
    
    // map
    @IBOutlet weak var mapView: MKMapView!
    var flatDriveView: FlatDriveViewManager!
    @IBOutlet weak var viewModeToggleButton: UIButton!
    
    
    // table
    @IBOutlet weak var tableView: UITableView!
    var manager: RETableViewManager!
    var driveStatsSection: RETableViewSection!
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = RETableViewManager(tableView: tableView, delegate: self)
        
        flatDriveView = FlatDriveViewManager()
        flatDriveView.mapView = mapView
        
        flatDriveView.trackPoints = drive.driveData.trackPoints
        flatDriveView.zoomToDrive()
        
        self.title = drive.trackName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("shareDrive"))
        
        driveStatsSection = addDriveStats()
    }
    
    override func viewDidAppear(animated: Bool) {
        PFAnalytics.trackEvent("viewAppeared", dimensions: ["viewName": "FeedDriveView"])
    }
    
    override func viewDidDisappear(animated: Bool) {
        PFAnalytics.trackEvent("viewDisappeared", dimensions: ["viewName": "FeedDriveView"])
    }
    
    // MARK: - Table manager
    
    func addDriveStats() -> RETableViewSection {
        var section = RETableViewSection()
        manager.addSection(section)
        
        let distance = RETextItem(title: "Distance", value: NSString(format: "%.2f miles", drive.driveData.distance.miles) as String)
        distance.enabled = false
        
        let maxSpeed = RETextItem(title: "Max speed", value: NSString(format: "%.2f mph", drive.driveData.maxSpeed.mph) as String)
        maxSpeed.enabled = false
        
        let avgSpeed = RETextItem(title: "Average speed", value: NSString(format: "%.2f mph", drive.driveData.averageSpeed.mph) as String)
        avgSpeed.enabled = false
        
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.SSS"
        timeFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        let time = timeFormatter.stringFromDate(NSDate(timeIntervalSince1970: drive.driveData.driveTime))

        
        let driveTime = RETextItem(title: "Drive time", value: time)
        driveTime.enabled = false
        
        let conditions = RETextItem(title: "Road conditions", value: drive.roadCondition)
        conditions.enabled = false
        
        let notes = RELongTextItem(title: nil, value: drive.notes)
        notes.enabled = false
        notes.cellHeight = 88
        
        section.addItem(distance)
        section.addItem(driveTime)
        section.addItem(maxSpeed)
        section.addItem(avgSpeed)
        section.addItem(conditions)
        
        if drive.notes != nil {
            section.addItem(notes)
        }
        
        return section
    }
    
    // MARK: - Misc
    
    func shareDrive() {
        // bring up action sheet to let user share the drive... somehow?
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        if let vc = destination as? FeedMapDetailViewController {
            vc.drive = drive
        }
    }
}
