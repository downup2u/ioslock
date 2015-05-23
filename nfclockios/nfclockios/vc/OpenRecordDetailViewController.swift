//
//  OpenRecordDetailViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/14.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class OpenRecordDetailViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableview: UITableView!
    var curLock = IteasyNfclock.db_lock()
    var lockOpenrecordArray = Array<IteasyNfclock.db_lock_open_record>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self        // Do any additional setup after loading the view.
        popDatePicker = PopDatePicker(sourceView: self.view)
        self.setMyCurDate(self.curDate)
        refreshData()
    }
    
    func refreshData(){
        var msgReq = IteasyNfclock.PkgLockGetLockOpenrecordReq.builder()
        msgReq.lockuuid = self.curLock.lockuuid
        msgReq.queryflag = IteasyNfclock.PkgLockGetLockOpenrecordReq.EnQueryFlag.QDate
        msgReq.pageflag = IteasyNfclock.PkgLockGetLockOpenrecordReq.EnPageFlag.PReturnall
        var endDate = curDate.add(days:1)
        var startdateString = self.curDate.formatted("yyyy-MM-dd 00:00:00")
        var enddateString = endDate.formatted("yyyy-MM-dd 00:00:00")
        msgReq.setQuerydatestart(startdateString)
        msgReq.setQuerydateend(enddateString)
        var msgReply = IteasyNfclock.PkgLockGetLockOpenrecordReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                
                self.lockOpenrecordArray = msgReply.lockopenrecordlist
                self.tableview.reloadData()
            }
        })
        
    }
    
    
    var popDatePicker : PopDatePicker?
    
    func onClickSelDate(){
        var initDate = self.curDate
        popDatePicker!.pick(self, initDate:initDate, dataChanged: {
            (newDate : NSDate, sourceView : UIView) -> () in
            
            self.setMyCurDate(newDate)
            self.refreshData()
        })
    }
    
    
    
    @IBOutlet weak var btnPrev: UIButton!

    
    @IBOutlet weak var btnPickDate: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var curDate = NSDate()
    @IBAction func onClickPrevDate(sender: AnyObject) {
        curDate = curDate.add(days:-1)
        var dateString = self.curDate.formatted("yyyy-MM-dd")
        println("curdate:\(dateString)")
        btnPickDate.setTitle(dateString, forState: UIControlState.Normal)
        self.datePickerChanged(dateString)
    }
    @IBAction func onClickNextDate(sender: AnyObject) {
        
        curDate = curDate.add(days:1)
        var dateString = self.curDate.formatted("yyyy-MM-dd")
        println("curdate:\(dateString)")
        btnPickDate.setTitle(dateString, forState: UIControlState.Normal)
        self.datePickerChanged(dateString)
    }
    @IBAction func onClickPickDate(sender: AnyObject) {
        
        self.onClickSelDate()
    }
    func setMyCurDate(date:NSDate){
        curDate = date
        var dateString = self.curDate.formatted("yyyy-MM-dd")
        btnPickDate.setTitle(dateString, forState: UIControlState.Normal)
        
        self.datePickerChanged(dateString)
    }
    
    
    
    
    
    func datePickerChanged(date : String){
        var todaydate = NSDate().formatted("yyyy-MM-dd")   
        refreshData()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return lockOpenrecordArray.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }

}
