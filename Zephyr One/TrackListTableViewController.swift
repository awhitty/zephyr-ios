//
//  TrackListTableViewController.swift
//  Zephyr One
//
//  Created by Austin Whittier on 6/9/15.
//  Copyright (c) 2015 Zephyr Racing. All rights reserved.
//

import UIKit

class TrackListTableViewController: UITableViewController, RETableViewManagerDelegate {
    
    var manager: RETableViewManager!
    
    var trackList: RETableViewSection!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let normal = IonIcons.imageWithIcon(ion_ios_list_outline, iconColor: UIColor.grayColor(), iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        
        let selected = IonIcons.imageWithIcon(ion_ios_list, iconColor: "#FF4C2D".UIColor, iconSize: 32, imageSize: CGSize(width: 32, height: 32))
        self.tabBarItem = UITabBarItem(title: "Tracks", image: normal, selectedImage: selected)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tracks"

        self.manager = RETableViewManager(tableView: self.tableView, delegate: self)
        
        self.trackList = addTrackList()
    }
    
    var tracks = [
        "Skyline": "skyline-final",
        "Laguna Seca": "laguna-seca",
        "Test Track": "original"
    ]
    
    func addTrackList() -> RETableViewSection {
        var section = RETableViewSection()
        manager.addSection(section)
        
        for (k,v) in tracks {
            let track = RETableViewItem(title: k, accessoryType: UITableViewCellAccessoryType.DisclosureIndicator) { (item) -> Void in
                item.deselectRowAnimated(true)
                
                var threedController = GameViewController()
                threedController.filename = "art.scnassets/\(v)"
                threedController.trackName = k
                
                var navCon = UINavigationController(rootViewController: threedController)
                
                self.presentViewController(navCon, animated: true, completion: nil)
            }
            
            section.addItem(track)
        }
        
        return section
    }

}
