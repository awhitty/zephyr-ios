//
//  SettingsCarSetup.swift
//  Zephyr One
//
//  Created by Owner on 4/30/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import Foundation

class SettingsCarSetupController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
   
    
    @IBOutlet weak var carBrandLabel: UITextField!
    @IBOutlet weak var carModelLabel: UITextField!
    @IBOutlet weak var carYearLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    
    override func viewDidAppear(animated: Bool) {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            self.saveButton.setTitle("Save", forState: UIControlState.Normal)
            if currentUser!["carBrand"] != nil {
                self.carBrandLabel.text = currentUser!["carBrand"] as! String?
            } else {
                self.carBrandLabel.placeholder = "Enter Car Manufacturer"
            }
            if currentUser!["carModel"] != nil {
                self.carModelLabel.text = currentUser!["carModel"] as! String?
            } else {
                self.carModelLabel.placeholder = "Enter Car Model"
            }
            if currentUser!["carYear"] != nil {
                self.carYearLabel.text = currentUser!["carYear"] as! String?
            } else {
                self.carYearLabel.placeholder = "Enter Car Year"
            }
        } else {
            self.saveButton.setTitle("Please Sign In", forState: UIControlState.Normal)
        }
        
        PFAnalytics.trackEvent("viewAppeared", dimensions: ["viewName": "SettingsCarSetupView"])
    }
    
    override func viewDidDisappear(animated: Bool) {
        PFAnalytics.trackEvent("viewDisappeared", dimensions: ["viewName": "SettingsCarSetupView"])
    }
    
    
    @IBAction func carBrandSaved(sender: AnyObject) {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            currentUser!["carBrand"] = self.carBrandLabel.text
            currentUser!["carModel"] = self.carModelLabel.text
            currentUser!["carYear"] = self.carYearLabel.text
            currentUser!.saveInBackground()
            self.saveButton.setTitle("Saved", forState: UIControlState.Normal)
        }
    }
}


