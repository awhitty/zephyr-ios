//
//  MoreTableViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/9/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController, RETableViewManagerDelegate {
    
    var manager: RETableViewManager!
    
    var facebookConnectSection: RETableViewSection!
    var facebookSection: RETableViewSection!
    var carListSection: RETableViewSection!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let normal = IonIcons.imageWithIcon(ion_ios_more_outline, iconColor: UIColor.grayColor(), iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        let selected = IonIcons.imageWithIcon(ion_ios_more, iconColor: self.view.tintColor, iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        self.tabBarItem = UITabBarItem(title: "Profile", image: normal, selectedImage: selected)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        self.manager = RETableViewManager(tableView: self.tableView, delegate: self)
        
        if PFUser.currentUser() == nil {
            facebookConnectSection = addFacebookConnect()
        } else {
            facebookSection = addFacebookSection()
            carListSection = addCarListSection()
            refreshCars()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        PFAnalytics.trackEvent("viewAppeared", dimensions: ["viewName": "MoreTableView"])
    }
    
    override func viewDidDisappear(animated: Bool) {
        PFAnalytics.trackEvent("viewDisappeared", dimensions: ["viewName": "MoreTableView"])
    }
    
    func addFacebookConnect() -> RETableViewSection {
        var section = RETableViewSection(headerTitle: "Connect with Facebook")
        self.manager.addSection(section)
        
        var signInButton = RETableViewItem(title: "Sign in", accessoryType: UITableViewCellAccessoryType.None) { (item) -> Void in
            item.deselectRowAnimated(true)
            PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: { (user, error) -> Void in
                if let user = user {
                    if user.isNew {
                        // set up new user
                    }
                    
                    self.facebookSection = self.addFacebookSection()
                    self.carListSection = self.addCarListSection()
                    self.manager.removeSection(self.facebookConnectSection)
                    
                    self.tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Error signing in", message: "Please try signing in through Facebook again in order to connect your account.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
        
        section.addItem(signInButton)
        
        return section
    }
    
    func addFacebookSection() -> RETableViewSection {
        var section = RETableViewSection(headerTitle: "Facebook")
        self.manager.addSection(section)
        
        let user = PFUser.currentUser()
        
        // name
        let fullname = user!["name"] as! String
        var name = RETextItem(title: "Name", value: fullname)
        section.addItem(name)
        
        var signOutButton = RETableViewItem(title: "Sign out", accessoryType: UITableViewCellAccessoryType.None) { (item) -> Void in
            item.deselectRowAnimated(true)
            
            PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
                // FIXME: some error things are happening in here
                self.facebookConnectSection = self.addFacebookConnect()
                
                self.manager.removeSection(self.facebookSection)
                self.manager.removeSection(self.carListSection)
                
                self.tableView.reloadData()
            })
        }
        
        name.style = UITableViewCellStyle.Value2
        name.enabled = false
        
        section.addItem(signOutButton)
        
        return section
    }
    
    func addCarListSection() -> RETableViewSection {
        var section = RETableViewSection(headerTitle: "Cars")
        self.manager.addSection(section)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshCars"), name: "Car updated", object: nil)
        
        return section
    }
    
    func refreshCars() {
        
        carListSection.removeAllItems()
        
        let user = PFUser.currentUser()
        
        var query = PFQuery(className: "Car")
        query.whereKey("owner", equalTo: user!.username!)
        
        query.findObjectsInBackgroundWithBlock { (cars, error) -> Void in
            if error == nil && cars != nil {
                for car in cars! as! [PFObject] {
                    // convert keys to strings to index without quote hell
                    let year = "year"
                    let make = "make"
                    let model = "model"
                    self.carListSection.addItem(RETableViewItem(title: "\(car[year]!) \(car[make]!) \(car[model]!)", accessoryType: UITableViewCellAccessoryType.DisclosureIndicator, selectionHandler: { (item) -> Void in
                        let carController = EditCarTableViewController()
                        carController.car = car
                        self.navigationController?.pushViewController(carController, animated: true)
                    }))
                }
            }
            
            self.carListSection.addItem(RETableViewItem(title: "Add a car", accessoryType: UITableViewCellAccessoryType.DisclosureIndicator, selectionHandler: { (item) -> Void in
                let carController = EditCarTableViewController()
                //                self.presentViewController(carController, animated: true, completion: nil)
                self.navigationController?.pushViewController(carController, animated: true)
            }))
            
            self.carListSection.reloadSectionWithAnimation(UITableViewRowAnimation.Automatic)
        }
    }
}
