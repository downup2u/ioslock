//
//  UserUserInfoViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/6.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class UserUserInfoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UserChooseDelegate, SWTableViewCellDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    var curLock = IteasyNfclock.db_lock()
    var lockUserArray = Array<IteasyNfclock.db_lock_user_user>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)

        var btnOK = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnOK.frame = CGRectMake(0, 0, 32, 32);
        btnOK.setImage(UIImage(named:"sq_tj"), forState: UIControlState.Normal)
        btnOK.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnOK.addTarget(self, action: "onClickAdd:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnOK)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        loaddata()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onDataCallback(notification: NSNotification){
        loaddata()
        
    }
    func loaddata(){
        var msgReq = IteasyNfclock.PkgLockGetLockUserReq.builder()
        msgReq.lockuuid = self.curLock.lockuuid
        var msgReply = IteasyNfclock.PkgLockGetLockUserReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                
                self.lockUserArray = msgReply.useruserlist
                self.tableview.reloadData()
            }
        })
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       // if(indexPath.section == 0){

            var cellUsr : AnyObject! = tableView.dequeueReusableCellWithIdentifier("cell")
//            var l1 = cellUsr.viewWithTag(101) as! UILabel
//            var l2 = cellUsr.viewWithTag(102) as! UILabel
            let useruser = lockUserArray[indexPath.row]
            (cellUsr as! MemberTableViewCell).labelName.text = useruser.truename
            (cellUsr as! MemberTableViewCell).labelDepartment.text = useruser.departmentname
            (cellUsr as! MemberTableViewCell).delegate = self
            (cellUsr as! MemberTableViewCell).useruser = useruser
            var rightbtns = NSMutableArray()
            rightbtns.sw_addUtilityButtonWithColor(UIColor.redColor(), icon: UIImage(named: "Delete"))
        
            (cellUsr as! MemberTableViewCell).setRightUtilityButtons(rightbtns as [AnyObject], withButtonWidth: 60)

            return cellUsr as! UITableViewCell
      //  }
        
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return lockUserArray.count
    }
    
    @IBAction func onClickAdd(sender: AnyObject) {
        let dvc  = self.storyboard?.instantiateViewControllerWithIdentifier("addlockuser") as! UserUserSelectToLockViewController
        dvc.delegate = self
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    
    func onUserChoosed(useruserlist:Array<String>){
        var msgReq = IteasyNfclock.PkgLockAddUsersReq.builder()
        msgReq.lockuuid = self.curLock.lockuuid
        for useruser in useruserlist{
            msgReq.useruuidlist.append(useruser)
        }
        var msgReply = IteasyNfclock.PkgLockAddUsersReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                self.loaddata()
            }
        })

    }
    
    
    func swipeableTableViewCell(cell: SWTableViewCell!,  didTriggerRightUtilityButtonWithIndex index: Int) {
         let celluser = cell as! MemberTableViewCell
        if(index == 0){
            //delete
            var msgReq = IteasyNfclock.PkgLockDeleteUsersReq.builder()
            msgReq.lockuuid = self.curLock.lockuuid
            msgReq.useruuidlist.append(celluser.useruser.relateduseruuid)
            var msgReply = IteasyNfclock.PkgLockDeleteUsersReply.builder()
            getLocalMsg(msgReq,msgReply,{
                if(msgReply.issuccess){
                    self.loaddata()
                }
            })

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
