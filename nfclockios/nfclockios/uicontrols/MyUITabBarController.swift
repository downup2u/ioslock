//
//  MyUITabBarController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-23.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class MyUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor  = UIColor.colorWithHex("#213F7F")
        
        var storyBoardTask = UIStoryboard(name:"lock",bundle:nil)
        var vc0 = storyBoardTask.instantiateViewControllerWithIdentifier("nav_opendoor") as! UINavigationController
        var vc1 = storyBoardTask.instantiateViewControllerWithIdentifier("nav_doormanager") as! UINavigationController
        var vc2 = storyBoardTask.instantiateViewControllerWithIdentifier("nav_me") as! UINavigationController
        
        vc0.tabBarItem = UITabBarItem(title:nil,image:UIImage(named:"km"), selectedImage:UIImage(named:"km_02"))
        vc1.tabBarItem = UITabBarItem(title:nil,image:UIImage(named:"mjgl"), selectedImage:UIImage(named:"mjgl_02"))
        vc2.tabBarItem = UITabBarItem(title:nil,image:UIImage(named:"wo"), selectedImage:UIImage(named:"wo_02"))
        
        let vcs = [vc0,vc1,vc2]
        for vc in vcs {
            vc.title = nil
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5,0,-5.5,0)
            
        }
        
        self.viewControllers = vcs
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
