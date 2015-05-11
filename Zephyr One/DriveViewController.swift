//
//  DriveViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/9/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DriveViewController: UIViewController, UIActionSheetDelegate, MKMapViewDelegate, DriveRecorderDelegate {
    
    // MARK: - View life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let normal = IonIcons.imageWithIcon(ion_ios_circle_outline, iconColor: UIColor.grayColor(), iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        let selected = IonIcons.imageWithIcon(ion_ios_circle_filled, iconColor: self.view.tintColor, iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        self.tabBarItem = UITabBarItem(title: "Drive", image: normal, selectedImage: selected)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        driveRecorder = DriveRecorder()
        driveRecorder.delegate = self
        
        mapView.delegate = self
        
        flatViewManager = FlatDriveViewManager()
        flatViewManager.mapView = mapView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        driveRecorder.checkLocationAuthorization()
        
        PFAnalytics.trackEvent("viewAppeared", dimensions: ["viewName": "DriveView"])
    }
    
    override func viewDidDisappear(animated: Bool) {
        PFAnalytics.trackEvent("viewDisappeared", dimensions: ["viewName": "DriveView"])
    }
    
    // MARK: - Map view
    
    @IBOutlet weak var mapView: MKMapView!
    var flatViewManager: FlatDriveViewManager!
    
    // MARK: - Drive recorder delegate
    
    func tick(elapsedTime: NSDate, speed: Double) {
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.SSS"
        timeFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        timeLabel.text = timeFormatter.stringFromDate(elapsedTime)
        
        
        speedLabel.text = NSString(format: "%.2f mph", speed) as String
        
        flatViewManager.trackPoints = self.driveRecorder.drive.driveData.trackPoints
    }
    
    // MARK: - Data logging
    
    var driveRecorder: DriveRecorder!
    
    // MARK: - Interface controls
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var lastLapLabel: UILabel!
    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBAction func toggleRecording(sender: UIButton) {
        if !driveRecorder.recording {
            driveRecorder.startRecording()
            sender.setTitle("Stop recording", forState: UIControlState.Normal)
        } else {
            driveRecorder.stopRecording()
            
            let actionSheet = UIActionSheet(title: "Would you like to save your drive?", delegate: self, cancelButtonTitle: "Discard drive", destructiveButtonTitle: nil, otherButtonTitles: "Save drive")
            
            actionSheet.actionSheetStyle = UIActionSheetStyle.Default
            actionSheet.showInView(self.view)
            
            sender.setTitle("Start recording", forState: UIControlState.Normal)
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            driveRecorder.saveRecording({ (completed, error) -> Void in
                // delay resetting drive...
                self.driveRecorder.resetDrive()
                
                if error != nil {
                    let alertController = UIAlertController(title: "Error saving drive", message: "Your drive could not be saved.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
            break
        default:
            driveRecorder.resetDrive()
        }
    }
    
    func displayLocationAuthorizationWarning() {
        // TODO: Implement this warning message
        // Should say something about how to enable location services in settings
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
