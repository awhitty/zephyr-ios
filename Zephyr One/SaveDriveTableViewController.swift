//
//  SaveDriveTableViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 6/1/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit

class SaveDriveTableViewController: UITableViewController, RETableViewManagerDelegate {
    
    var manager: RETableViewManager!
    var drive: Drive!
    
    var trackTitle: RETextItem!
    var roadConditions: RESegmentedItem!
    var notes: RELongTextItem!
    
    var selectedCar: PFObject!
    
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
        
        self.manager = RETableViewManager(tableView: tableView, delegate: self)
        
        self.title = "Save drive"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Discard", style: .Plain, target: self, action: Selector("confirmCancel"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("validateAndSave"))
        
        addInfoSection()
//        addDriveDataSection()
    }
    
    func addInfoSection() -> RETableViewSection {
        var section = RETableViewSection()
        self.manager.addSection(section)
        
        var trackTitle = RETextItem(title: "Track title", value: nil, placeholder: "Laguna Seca")
        var roadConditions = RESegmentedItem(title: "Road conditions", segmentedControlTitles: ["Dry", "Wet"], value: 0)
        var car = RERadioItem(title: "Car", value: nil) { (item) -> Void in
            item.deselectRowAnimated(true)
            
            var query = PFQuery(className: "Car")
            
            let user = PFUser.currentUser()
            query.whereKey("owner", equalTo: user!.username!)
            
            var options = query.findObjects()
            var stringOptions = options?.map({ ($0["make"] as! String) + " " + ($0["model"] as! String) })
            
            var optionsController = RETableViewOptionsController(item: item, options: stringOptions, multipleChoice: false, completionHandler: { (selected) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                
                if selected != nil {
                    self.selectedCar = options?[selected.indexPath().row] as? PFObject
                    item.value = selected.title
                    
                    item.reloadRowWithAnimation(.None)
                }
            })
            
            optionsController.delegate = self
            self.navigationController?.pushViewController(optionsController, animated: true)
            
        }
        var notes = RELongTextItem(value: nil, placeholder: "Drive notes")
        notes.cellHeight = 88
        
        section.addItem(trackTitle)
        section.addItem(roadConditions)
        section.addItem(car)
        section.addItem(notes)
        
        return section
    }
    
    func confirmCancel() {
        let alert = UIAlertController(title: "Please confirm", message: "Are you sure you would like to discard your drive?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Discard drive", style: UIAlertActionStyle.Destructive, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func validateAndSave() {
        // this is where
    }
}
