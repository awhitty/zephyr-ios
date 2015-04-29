//
//  MoreLoginController.swift
//  Zephyr One
//
//  Created by Owner on 4/29/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import Foundation

class MoreLoginController: UIViewController {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentUser = PFUser.currentUser()
        
        
        if currentUser != nil {
            self.username.text = currentUser?.username //need to get user first name and last name
            self.signInButton.setTitle("Sign out", forState: UIControlState.Normal)
        } else {
            self.username.text = "not signed in"
            self.signInButton.setTitle("Sign in", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func signInPressed(sender: UIButton) {
//        sender.setTitle("Sign out", forState: UIControlState.Normal)
        
        println("We would sign in here")
    }
}