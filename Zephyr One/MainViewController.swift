//
//  MainViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/9/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let drive = UIStoryboard(name: "Drive", bundle: nil)
        let driveVC = drive.instantiateInitialViewController() as! UIViewController
        
        let feed = UIStoryboard(name: "Feed", bundle: nil)
        let feedVC = feed.instantiateInitialViewController() as! UIViewController
        
        let more = UIStoryboard(name: "More", bundle: nil)
        let moreVC = more.instantiateInitialViewController() as! UIViewController
        
        self.viewControllers = [feedVC, driveVC, moreVC]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
