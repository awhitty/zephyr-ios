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

class DriveViewController: UIViewController, MKMapViewDelegate, DriveRecorderDelegate {
    
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
    }
    
    // MARK: - Map view
    
    @IBOutlet weak var mapView: MKMapView!
    
    func mapRegion() -> MKCoordinateRegion {
        var region = MKCoordinateRegion()
        
        let location = self.driveRecorder.drive.driveData.trackPoints.last!
        
        region.center = location.coordinate
        region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        return region
    }
    
    func loadMap() {
        if self.driveRecorder.drive.driveData.trackPoints.count > 0 {
            self.mapView.region = mapRegion()
        }
    }
    
    
    
    // MARK: - Drive recorder delegate
    
    func tick(elapsedTime: NSDate, location: CLLocation, speed: Double) {
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
            sender.setTitle("Start recording", forState: UIControlState.Normal)
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
