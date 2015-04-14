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

class FeedTableViewController: PFQueryTableViewController {
    
    var drives = ["First drive...", "Second drive"]
    
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
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Drive")
        
        query.orderByDescending("createdAt")
        
        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Card") as! CardCell
        
        cell.titleLabel.text = object["user"] as? String
        cell.subtitleLabel.text = object["carDescription"] as? String

        if let date = object.createdAt {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            cell.dateLabel.text = dateFormatter.stringFromDate(date)
        }
        
        return cell
    }
}
