//
//  UserUserSelectToLockViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/7.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class UserUserSelectToLockViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var delegate:UserChooseDelegate?
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)
        
        var btnOK = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnOK.frame = CGRectMake(0, 0, 32, 32);
        btnOK.setBackgroundImage(UIImage(named: "sq_tj"), forState: UIControlState.Normal)
        btnOK.addTarget(self, action: "onClickOK:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnOK)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onDataCallback(notification: NSNotification){
        //loaddata()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // if(indexPath.section == 0){
        
        var cellUsr : AnyObject! = tableView.dequeueReusableCellWithIdentifier("cell")
        
        let useruser = GlobalSessionUser.shared.userSelArray[indexPath.row]
        cellUsr.textLabel?!.text = useruser.truename
        var str = useruser.departmentname
        var attribute = NSMutableAttributedString(string: str)
        cellUsr.detailTextLabel?!.attributedText = attribute
      //  cellUsr.accessoryType = UITableViewCellAccessoryType.Checkmark
        
    
        
        return cellUsr as! UITableViewCell
        //  }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return GlobalSessionUser.shared.userSelArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryType.Checkmark ? UITableViewCellAccessoryType.None : UITableViewCellAccessoryType.Checkmark
            }
        }
    }
    
    func onClickOK(sender: UIViewController) {
        
        var useruserlist = Array<String>()
        for(var i = 0;i < GlobalSessionUser.shared.userSelArray.count ; i++ ){
            var path = NSIndexPath(forRow:i,inSection:0)
            if let cell = tableview.cellForRowAtIndexPath(path){
                if(cell.accessoryType == UITableViewCellAccessoryType.Checkmark){
                    useruserlist.append(GlobalSessionUser.shared.userSelArray[i].relateduseruuid)
                }
            }
        }
        
        if(useruserlist.count > 0){
            self.delegate?.onUserChoosed(useruserlist)
            self.navigationController?.popViewControllerAnimated(true)
        }
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
