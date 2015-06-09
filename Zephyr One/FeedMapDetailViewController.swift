//
//  FeedMapDetailViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 6/7/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit
import MapKit

class FeedMapDetailViewController: UIViewController {
    
    var drive: Drive!
    var driveManager = FlatDriveViewManager()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        driveManager.mapView = self.mapView
        driveManager.trackPoints = drive.driveData.trackPoints
        driveManager.zoomToDrive()
        
        self.title = drive.trackName
        
        let closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: Selector("close"))
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
