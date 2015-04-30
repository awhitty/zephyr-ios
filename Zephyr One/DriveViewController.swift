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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        driveRecorder.checkLocationAuthorization()
    }
    
    // MARK: - Map view
    
    @IBOutlet weak var mapView: MKMapView!
    
    func mapRegion() -> MKCoordinateRegion {
        let location = self.driveRecorder.drive.driveData.trackPoints.last!
        
        return MKCoordinateRegionMakeWithDistance(location.coordinate, 20, 20)
    }
    
    func loadMap() {
        if self.driveRecorder.drive.driveData.trackPoints.count > 0 {
            self.mapView.region = mapRegion()
            self.mapView.addOverlay(self.polyLine())
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polyline = overlay as! MKPolyline
            var renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 3
            return renderer
        }
        
        return nil
    }
    
    func polyLine() -> MKPolyline {
        var coords = driveRecorder.drive.driveData.trackPoints.map { $0.coordinate }
        coords.reserveCapacity(driveRecorder.drive.driveData.trackPoints.count)
        
        return MKPolyline(coordinates: &coords, count: coords.count)
    }
    
    // MARK: - Drive recorder delegate
    
    func tick(elapsedTime: NSDate, speed: Double) {
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.SSS"
        timeFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        timeLabel.text = timeFormatter.stringFromDate(elapsedTime)
        
        
        speedLabel.text = NSString(format: "%.2f mph", speed) as String
        
        loadMap()
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
        case 0:
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
