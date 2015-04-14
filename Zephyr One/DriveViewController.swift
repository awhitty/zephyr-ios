//
//  DriveViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 4/9/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit

class DriveViewController: UIViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let normal = IonIcons.imageWithIcon(ion_ios_circle_outline, iconColor: UIColor.grayColor(), iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        let selected = IonIcons.imageWithIcon(ion_ios_circle_filled, iconColor: self.view.tintColor, iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        self.tabBarItem = UITabBarItem(title: "Drive", image: normal, selectedImage: selected)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBOutlet weak var stopWatchDisplay: UILabel!
//
//    @IBAction func startStopWatch(sender: AnyObject) {
//    }
//    
//    @IBAction func stopStopWatch(sender: AnyObject) {
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
