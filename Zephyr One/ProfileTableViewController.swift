//
//  ProfileTableViewController.swift
//  Zephyr One
//
//  Created by Owner on 5/12/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import Foundation

class ProfileTableViewController: UITableViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let normal = IonIcons.imageWithIcon(ion_ios_more_outline, iconColor: UIColor.grayColor(), iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        let selected = IonIcons.imageWithIcon(ion_ios_more, iconColor: self.view.tintColor, iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidDisappear(animated: Bool) {
        PFAnalytics.trackEvent("viewDisappeared", dimensions: ["viewName": "MoreTableView"])
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
