//
//  EditCarTableViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 5/25/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit

class EditCarTableViewController: UITableViewController, RETableViewManagerDelegate {
    
    var manager: RETableViewManager!
    var car: PFObject!
    
    init() {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    override init!(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(style: UITableViewStyle.Grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser.currentUser()
        
        if car == nil {
            self.title = "Add a car"
            car = PFObject(className: "Car")
            car["owner"] = user?.username
        } else {
            self.title = "Edit car"
        }
        
        self.manager = RETableViewManager(tableView: self.tableView, delegate: self)
        let section = RETableViewSection()
        manager.addSection(section)
        
        var make = RETextItem(title: "Make", value: car["make"] as? String, placeholder: "BMW (required)")
        var model = RETextItem(title: "Model", value: car["model"] as? String, placeholder: "i8 (required)")
        var year = RENumberItem(title: "Year", value: car["year"] as? String, placeholder: "2015 (required)")
        
        make.validators = ["presence"]
        model.validators = ["presence"]
        year.validators = ["presence"]
        
        make.style = UITableViewCellStyle.Value2
        model.style = UITableViewCellStyle.Value2
        year.style = UITableViewCellStyle.Value2
        
        section.addItem(make)
        section.addItem(model)
        section.addItem(year)
        
        let saveSection = RETableViewSection()
        manager.addSection(saveSection)
        
        saveSection.addItem(RETableViewItem(title: "Save car", accessoryType: UITableViewCellAccessoryType.None, selectionHandler: { (item) -> Void in
            // should validate fields
            
            self.car["make"] = make.value
            self.car["model"] = model.value
            self.car["year"] = year.value
            
            self.car.save()
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "Car updated", object: self.car))
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        
    }

}
