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
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    var isSignedIn = true;
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var currentUser = PFUser.currentUser()
    
        if currentUser != nil {
            self.username.text = currentUser!["name"] as! String?
            self.signInButton.setTitle("Sign out", forState: UIControlState.Normal)
        
        } else {
            self.username.text = "Please Sign In"
            self.signInButton.setTitle("Sign in", forState: UIControlState.Normal)
            isSignedIn = false;
        }
    }
    
    @IBAction func signInPressed(sender: UIButton) {
        sender.setTitle("Sign out", forState: UIControlState.Normal)
        var currentUser = PFUser.currentUser()
        
        /*
         * IF USER IS LOGGING IN
         */
        if (!isSignedIn) {
        
            PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: {
                (user: PFUser?, error: NSError?) -> Void in
                
                if let user = user {
                    if user.isNew {
                        println("User signed up and logged in through Facebook!")
                    } else {
                        println("User logged in through Facebook!")
                    }
                    
                    /*
                     * USING FBSDK TO GRAB PROFILE INFORMATION
                     */
                    FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                        if error == nil {
                            println(result)
                            user["name"] = result["name"]
                            user["gender"] = result["gender"]
                            user["email"] = result["email"]
                            user["facebookId"] = result["id"]
                            
                            let facebookId = result["id"]
                            
    
                            /*
                             * SETTING PROFILE PICTURE
                             */
                            let pictureURL = "https://graph.facebook.com/\(facebookId)/picture?type=large&return_ssl_resources=1"
                            var URLRequest = NSURL(string: pictureURL)
                            var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                            NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
                                if error == nil {
                                    var picture = PFFile(data: data)
                                    println(picture)
                                    user.setObject(picture, forKey: "profilePicture")
//                                    user.saveInBackground()
                                }
                                else {
                                    println("Error: \(error.localizedDescription)")
                                }
                            })
                            
                            /*
                             * SAVING PROFILE AND SAVING SESSION INFORMATION
                             */
                            user.saveEventually()
//                            currentUser = PFUser.currentUser()
                            
                            let name = result["name"]
                            self.username.text = name as! String?
                            
                            self.signInButton.setTitle("Sign out", forState: UIControlState.Normal)
                            self.isSignedIn = true;

                        } else {
                            
                        }
                    })
                    
                } else {
                    println("Uh oh. The user cancelled the Facebook login.")
                }
            })
            
        /*
         * IF USER CLICKS LOG OUT
         */
        } else {
            
            PFUser.logOut()
            var currentUser = PFUser.currentUser()
            self.username.text = "Please Sign In"
            self.signInButton.setTitle("Sign in", forState: UIControlState.Normal)
            isSignedIn = false;

        }
    }
}