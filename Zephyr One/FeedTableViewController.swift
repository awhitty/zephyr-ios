//
//  FeedTableViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/9/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Parse

class FeedTableViewController: PFQueryTableViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let normal = IonIcons.imageWithIcon(ion_ios_paper_outline, iconColor: UIColor.grayColor(), iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        let selected = IonIcons.imageWithIcon(ion_ios_paper, iconColor: self.view.tintColor, iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        self.tabBarItem = UITabBarItem(title: "Feed", image: normal, selectedImage: selected)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.clearColor()
//        self.tableView.rowHeight = UITableViewAutomaticDimension;

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        PFAnalytics.trackEvent("viewAppeared", dimensions: ["viewName": "FeedTableView"])
    }
    
    override func viewDidDisappear(animated: Bool) {
        PFAnalytics.trackEvent("viewDisappeared", dimensions: ["viewName": "FeedTableView"])
    }
    
    override func queryForTable() -> PFQuery {
        var query = Drive.query()
        
        query!.orderByDescending("createdAt")
        
        return query!
    }
    
    @IBAction func feedModeChanged(sender: UISegmentedControl) {
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Card") as! CardCell
        
        let drive: Drive = object as! Drive
        
        cell.titleLabel.text = drive.user
        cell.subtitleLabel.text = drive.carDescription
        
        cell.distanceLabel.text = NSString(format: "%.2f meters", drive.driveData.distance) as String

        if let date = object.createdAt {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            cell.dateLabel.text = dateFormatter.stringFromDate(date)
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        if let flatDriveView = destination as? FeedDriveViewController {
            
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                flatDriveView.drive = objectAtIndexPath(indexPath) as! Drive
            }
        }
    }
    
}
