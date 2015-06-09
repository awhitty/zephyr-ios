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
            self.mapView.addOverlays(self.coloredSegments())
        }
    }
    
    func zoomToDrive() {
        mapView.setVisibleMapRect(polyLine().boundingMapRect, edgePadding: UIEdgeInsets(top: 80, left: 80, bottom: 80, right: 80), animated: true)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if let polyline = overlay as? MulticolorPolylineSegment {
            var renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = polyline.color
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
    
    func coloredSegments() -> [MulticolorPolylineSegment] {
        var segments = [MulticolorPolylineSegment]()
        for i in 0...trackPoints.count - 2 {
            let firstPoint = trackPoints[i]
            let secondPoint = trackPoints[i + 1]
            
            var coords = [CLLocationCoordinate2D]()
            coords.reserveCapacity(2)
            
            coords.append(firstPoint.location.coordinate)
            coords.append(secondPoint.location.coordinate)
            
            let accel = secondPoint.acceleration
            
            var color = "#89D3FF".UIColor
            
            let cutoff = 1.0
                        
            if accel > cutoff {
                color = "#9EFFB9".UIColor
            }
            
            if accel < -1*cutoff {
                color = "#FF4C2D".UIColor
            }
            
            let segment = MulticolorPolylineSegment(coordinates: &coords, count: 2)
            segment.color = color
            segments.append(segment)
        }
        
        return segments
    }
}
