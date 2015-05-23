//
//  RootNavigationViewController.swift
//  WorkTest
//
//  Created by wxqdev on 14-10-15.
//  Copyright (c) 2014年 wxqdev. All rights reserved.
//

import UIKit

class RootNavigationViewController: UINavigationController ,UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationBar.barTintColor = UIColor.colorWithHex("#4B6CB1")
        var globals_attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(20)
        ]
        self.navigationBar.titleTextAttributes = globals_attributes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(navigationController: UINavigationController,
        willShowViewController viewController: UIViewController,
        animated: Bool){
            if(viewController is LoginViewController){
                //登录页／门禁管理／我
                self.navigationBarHidden = true
            }
            else if(viewController is DoorManagementViewController
            || viewController is DoorMyProfileViewController
                || viewController is DoorOpenViewController
                || viewController is SuccessViewController){
                self.navigationBarHidden = false
                viewController.navigationItem.leftBarButtonItem = nil
               // viewController.navigationItem.hidesBackButton = true
                viewController.navigationItem.rightBarButtonItem = nil
            }
            else{
                if(self.navigationBarHidden){
                    //显示导航条
                    self.navigationBarHidden = false
                }
                
                var btnBack = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                btnBack.frame = CGRectMake(0, 0, 32, 32);
                btnBack.setBackgroundImage(UIImage(named: "jt"), forState: UIControlState.Normal)
                btnBack.setBackgroundImage(UIImage(named: "jt_01"), forState: UIControlState.Selected)
                btnBack.addTarget(self, action: "onClickBack:", forControlEvents: UIControlEvents.TouchUpInside)
                var leftBarButtonItem = UIBarButtonItem(customView:btnBack)
                //  let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow_active"), style: .Plain, target: self, action: "onClickBack:")
                viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
            }
        // MainTaskViewController
            
    }
    func onClickBack(sender: UIViewController) {
        self.popViewControllerAnimated(true)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
