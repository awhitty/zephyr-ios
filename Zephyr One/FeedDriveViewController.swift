//
//  FeedDriveViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 5/8/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit
import MapKit

class FeedDriveViewController: UIViewController {
    
    var drive: Drive!
    @IBOutlet weak var mapView: MKMapView!
    var flatDriveView: FlatDriveViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        flatDriveView = FlatDriveViewManager()
        flatDriveView.mapView = mapView
        
        flatDriveView.trackPoints = drive.driveData.trackPoints
        flatDriveView.zoomToDrive()
        
        self.title = drive.trackName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("shareDrive"))
    }
    
    override func viewDidAppear(animated: Bool) {
        PFAnalytics.trackEvent("viewAppeared", dimensions: ["viewName": "FeedDriveView"])
    }
    
    override func viewDidDisappear(animated: Bool) {
        PFAnalytics.trackEvent("viewDisappeared", dimensions: ["viewName": "FeedDriveView"])
    }
    
    func shareDrive() {
        // bring up action sheet to let user share the drive... somehow?
    }
}
