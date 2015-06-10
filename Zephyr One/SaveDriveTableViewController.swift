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
    
    
    // info section
    var infoSection: RETableViewSection!
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
        
        infoSection = addInfoSection()
//        addDriveDataSection()
    }
    
    func addInfoSection() -> RETableViewSection {
        var section = RETableViewSection()
        self.manager.addSection(section)
        
        trackTitle = RETextItem(title: "Track title", value: nil, placeholder: "Laguna Seca")
        roadConditions = RESegmentedItem(title: "Road conditions", segmentedControlTitles: ["Dry", "Wet"], value: 0)
        var car = RERadioItem(title: "Car", value: nil) { (item) -> Void in
            item.deselectRowAnimated(true)
            
            var query = PFQuery(className: "Car")
            
            let user = PFUser.currentUser()
            query.whereKey("owner", equalTo: user!.username!)
//            query.whereKey("owner", equalTo: "awhitty")
            
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
        notes = RELongTextItem(value: nil, placeholder: "Drive notes")
        notes.cellHeight = 88
        
        trackTitle.validators = ["presence"]
        
        section.addItem(trackTitle)
        section.addItem(roadConditions)
        section.addItem(car)
        section.addItem(notes)
        
        return section
    }
    
    func validateAndSave() {
        if self.manager.errors.count > 0 {
            let errorString = self.manager.errors.map({ $0.localizedDescription }).reduce("", combine: { "\($0) \n \($1)" })
            let alert = UIAlertController(title: "Please fix these errors", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            drive.trackName = trackTitle.value
            drive.user = PFUser.currentUser()!
            drive.car = selectedCar
            drive.roadCondition = ["Dry", "Wet"][roadConditions.value]
            drive.facebookId = PFUser.currentUser()!["facebookId"] as! String
            drive.notes = notes.value
            
            drive.saveWithData({ (completed, error) -> Void in
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            })
            // We want to navigate to a drive view with the drive info from here
        }
    }
    
    func confirmCancel() {
        let alert = UIAlertController(title: "Please confirm", message: "Are you sure you would like to discard your drive?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Discard drive", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
            // TODO: Need to discard the drive here and notify view controller
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
