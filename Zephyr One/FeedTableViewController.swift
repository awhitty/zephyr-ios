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
    
    @IBOutlet weak var feedFilterControl: UISegmentedControl!
    
    var friendList = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let normal = IonIcons.imageWithIcon(ion_ios_paper_outline, iconColor: UIColor.grayColor(), iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        let selected = IonIcons.imageWithIcon(ion_ios_paper, iconColor: self.view.tintColor, iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        self.tabBarItem = UITabBarItem(title: "Feed", image: normal, selectedImage: selected)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.clearColor()
        
        FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
            if error == nil {
                var resultdict = result as! NSDictionary
                var data : NSArray = result.objectForKey("data") as! NSArray
                
                for d in data {
                    let value = d as! NSDictionary
                    self.friendList.append(value.objectForKey("id") as! String)
                }
            }
            
            if self.feedFilterControl.selectedSegmentIndex == 1 {
                self.loadObjects()
            }
        })
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
        
        switch feedFilterControl.selectedSegmentIndex {
        case 0:
            if let user = PFUser.currentUser() {
                query?.whereKey("facebookId", equalTo: user["facebookId"]!)
            }
            break
        case 1:
            if let user = PFUser.currentUser() {
                query?.whereKey("facebookId", containedIn: friendList)
            }
            break
        default:
            break
        }
        
        return query!
    }
    
    @IBAction func feedModeChanged(sender: UISegmentedControl) {
        if self.objects?.count > 0 {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
        self.loadObjects()
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
