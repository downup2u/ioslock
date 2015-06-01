//
//  LockManagementViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-2.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class LockManagementViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,OfflineTimeChooseDelegate {

    @IBOutlet weak var tableview: UITableView!

    @IBOutlet weak var labelLockDeviceid: UILabel!
    var curLock = IteasyNfclock.db_lock()
    var lockOpenrecordArray = Array<IteasyNfclock.db_lock_open_record>()
    var lockUserCount = 0
    var lockOpenrecordCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)
        
        labelLockDeviceid.text = curLock.lockdeviceid
        loaddata()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onDataCallback(notification: NSNotification){
        println("onDataCallback->current thread = \(NSThread.currentThread())");
      
    }
    func loaddata(){
        var msgReq = IteasyNfclock.PkgLockGetLockInfoReq.builder()
        msgReq.lockuuid = self.curLock.lockuuid
        var msgReply = IteasyNfclock.PkgLockGetLockInfoReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                
                self.lockOpenrecordArray = msgReply.lockopenrecordlist
                self.lockUserCount = Int(msgReply.userusercount)
                self.lockOpenrecordCount = Int(msgReply.openrecordcount)
                self.tableview.reloadData()
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    @IBAction func onUpdateLockPasswordButtonClicked(sender: AnyObject) {
        var storyBoardTask = UIStoryboard(name:"lock",bundle:nil)
        var dvc = storyBoardTask.instantiateViewControllerWithIdentifier("lockupdatepassword") as! LockUpdatePasswordViewController
        dvc.curLock = curLock
        navigationController?.pushViewController(dvc,animated: true)
    }
    
    @IBAction func onGetUserUserNumberButtonClicked(sender: AnyObject) {
        var storyBoardTask = UIStoryboard(name:"lock",bundle:nil)
        var dvc = storyBoardTask.instantiateViewControllerWithIdentifier("useruserinfo") as! UserUserInfoViewController
        dvc.curLock = curLock
        navigationController?.pushViewController(dvc,animated: true)
    }
    
    @IBAction func onClickLockLogoff(sender: AnyObject) {
        
        var storyBoardTask = UIStoryboard(name:"lock",bundle:nil)
        var dvc = storyBoardTask.instantiateViewControllerWithIdentifier("locklogoff") as! LockLogoffViewController
        dvc.curLock = curLock
        navigationController?.pushViewController(dvc,animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            var cell : AnyObject! = tableView.dequeueReusableCellWithIdentifier("celllock")
            var celllock = cell as! UITableViewCell
            var l1 = celllock.viewWithTag(1001) as! UILabel
            var l2 = celllock.viewWithTag(1002) as! UILabel
            var b1 = celllock.viewWithTag(1003) as! UIButton
            var b2 = celllock.viewWithTag(1004) as! UIButton
            
            if(indexPath.row == 0){
                l1.text = "锁具位置"
                l2.text = curLock.lockposition
                b1.hidden = true
                b2.hidden = true
                celllock.accessoryType = UITableViewCellAccessoryType.None
                
            }
            else if(indexPath.row == 1){
                l1.text = "锁具口令"
                //l2.text = curLock.lockpasswd
                l2.hidden = true
                b1.hidden = true
                b2.hidden = false
                celllock.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                b2.addTarget(self, action: "onUpdateLockPasswordButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)

            }
            else if(indexPath.row == 2){
                l1.text = "授权数量"
                l2.hidden = true
                b1.hidden = false
                b2.hidden = true
                b1.setTitle("\(lockUserCount)个", forState: UIControlState.Normal)
                //b1.titleLabel?.text = "\(lockUserCount)"
                celllock.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                b1.addTarget(self, action: "onGetUserUserNumberButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            else if(indexPath.row == 3){
                l1.text = "离网时间"
                l2.hidden = true
                b1.hidden = false
                b2.hidden = true
                
                b1.setTitle("\(curLock.lockofflinetime)分钟", forState: UIControlState.Normal)
               // b1.titleLabel?.text =
                celllock.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                b1.addTarget(self, action: "onOfflineTimeClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            return celllock
        }
        else {
            var cellopenrecord : AnyObject! = tableView.dequeueReusableCellWithIdentifier("celllockopenrecord")
            
            
            var img1 = cellopenrecord.viewWithTag(1001) as! UIImageView
            var l1 = cellopenrecord.viewWithTag(1002) as! UILabel
            var l2 = cellopenrecord.viewWithTag(1003) as! UILabel
            var openrecord = self.lockOpenrecordArray[indexPath.row]
            l1.text = openrecord.opentime
            l2.text = GlobalSessionUser.shared.getUserUserName(openrecord.useruuid)
            
            if(openrecord.openaction == "password"){
               // l1.text = openrecord.
            }
            else{
                
            }
            
            return cellopenrecord as! UITableViewCell
        }
        
        
    }
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String{
//        if( section == 0){
//            return ""
//        }
//        return "开门记录"
//    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if( section == 0){
            return 4
        }
        return lockOpenrecordArray.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if( section == 0){
            return 0
        }
        return 50
    }
    
    @IBAction func onOfflineTimeClicked(sender: AnyObject) {
        var dvc = self.storyboard?.instantiateViewControllerWithIdentifier("setofflinetime") as! SetOfflineTimeViewController
        dvc.defaultofflinetime = Int(curLock.lockofflinetime)
        dvc.delegate = self
        self.navigationController?.pushViewController(dvc,animated: true)
    }
    func onOfflineChoosed(offlinetime:Int){
        var msgReq = IteasyNfclock.PkgLockSetOfflineTimeReq.builder()
        msgReq.offlinetime = Int32(offlinetime)
        msgReq.lockuuid = curLock.lockuuid
        var msgReply = IteasyNfclock.PkgLockSetOfflineTimeReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                showSuccess("", "设置锁离网时间成功")
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            else{
                showError("",msgReply.err)
            }
        })
        var lockbuilder = IteasyNfclock.db_lockBuilder()
        lockbuilder.mergeFrom(curLock)
        lockbuilder.lockofflinetime = Int32(offlinetime)
        curLock = lockbuilder.build()
        self.tableview.reloadData()

    }
    @IBAction func clickMoreOpenRecordDetail(sender: AnyObject) {
        var dvc = self.storyboard?.instantiateViewControllerWithIdentifier("openrecorddetail") as! OpenRecordDetailViewController
        dvc.curLock = curLock
        navigationController?.pushViewController(dvc,animated: true)
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){
            return nil
        }
         var view = UIView()
        // 2.在标题视图中添加一个按钮
        var button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        // 添加标题按钮的监听方法
        button.tag = section
        button.addTarget(self, action: Selector("clickMoreOpenRecordDetail:"), forControlEvents: UIControlEvents.TouchUpInside)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.setImage(UIImage(named:"gd"), forState: UIControlState.Normal)
        //button.setBackgroundImage(UIImage(named:"gd"), forState: UIControlState.Normal)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        var headerLabel = UILabel()
        headerLabel.text = "开门记录"
        
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(headerLabel)
        view.addSubview(button)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[lab]-[btn(50)]-10-|", options: nil, metrics: nil, views:["lab":headerLabel, "btn":button]))
      
//        button.setTitleColor(UIColor.colorWithHex("#1E90FF"), forState: UIControlState.Normal)
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[lab]|",options:nil, metrics:nil, views:["lab":headerLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[btn]|",options:nil, metrics:nil, views:["btn":button]))
        
        view.backgroundColor = UIColor.colorWithHex("#CAD9F8")

        return view
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var selsection = indexPath.section
        var selrow = indexPath.row
        if(selsection == 0){
            if(selrow == 1){
                //锁具口令
            }
            else if(selrow == 2){
                //授权人信息
            }
        }

    }

}
