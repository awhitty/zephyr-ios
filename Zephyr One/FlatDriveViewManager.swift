//
//  2DDriveView.swift
//  Zephyr One
//
//  Created by Austin Whittier on 5/8/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit
import MapKit

class FlatDriveViewManager: NSObject, MKMapViewDelegate {
    
    var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    var trackPoints: [DriveDataPoint]! {
        didSet {
            updateUI()
        }
    }

    func updateUI() {
        if trackPoints.count > 1 {
            self.mapView.addOverlay(self.polyLine())
        }
    }
    
    func zoomToDrive() {
        mapView.setVisibleMapRect(polyLine().boundingMapRect, edgePadding: UIEdgeInsets(top: 80, left: 80, bottom: 80, right: 80), animated: true)
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
        var coords = trackPoints.map { $0.location.coordinate }
        coords.reserveCapacity(trackPoints.count)
        
        return MKPolyline(coordinates: &coords, count: coords.count)
    }
}
