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
    
    var isSignedIn = true;
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            self.username.text = currentUser?.username //need to get user first name and last name
            self.signInButton.setTitle("Sign out", forState: UIControlState.Normal)
        
        } else {
            self.username.text = "Please Sign In"
            self.signInButton.setTitle("Sign in", forState: UIControlState.Normal)
            isSignedIn = false;
        }
    }
    
    @IBAction func signInPressed(sender: UIButton) {
//        sender.setTitle("Sign out", forState: UIControlState.Normal)
        var currentUser = PFUser.currentUser()
        if (!isSignedIn) {
            PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: {
                (user: PFUser?, error: NSError?) -> Void in
                if let user = user {
                    if user.isNew {
                        println("User signed up and logged in through Facebook!")
                    } else {
                        println("User logged in through Facebook!")
                    }
                    currentUser = PFUser.currentUser()
                    self.username.text = currentUser?.username //need to get user first name and last name
                    self.signInButton.setTitle("Sign out", forState: UIControlState.Normal)
                    self.isSignedIn = true;
                } else {
                    println("Uh oh. The user cancelled the Facebook login.")
                }
            })
        } else {
            PFUser.logOut()
            var currentUser = PFUser.currentUser()
            self.username.text = "Please Sign In"
            self.signInButton.setTitle("Sign in", forState: UIControlState.Normal)
            isSignedIn = false;

        }
    }
}