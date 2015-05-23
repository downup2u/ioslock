//
//  DoorOpenPopViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-10.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class DoorOpenPopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)
        
        loaddata()
        addopenrecord()
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var curLock = IteasyNfclock.db_lock()
    func onDataCallback(notification: NSNotification){
        println("onDataCallback->current thread = \(NSThread.currentThread())");

    }
    func addopenrecord(){
        var msgReq = IteasyNfclock.PkgLockAddOpenrecordReq.builder()
        var msgOpenrecord = IteasyNfclock.db_lock_open_record.builder()
        msgOpenrecord.lockuuid = self.curLock.lockuuid
        msgOpenrecord.openaction = "密码"
        msgReq.record = msgOpenrecord.build()
        var msgReply = IteasyNfclock.PkgLockAddOpenrecordReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                
            }
        })
       
    }
    @IBOutlet weak var labelpassword: UILabel!
    @IBOutlet weak var labellockid: UILabel!
    @IBOutlet weak var labellockposition: UILabel!
    
    func loaddata(){
        labellockid.text = curLock.lockdeviceid
        labellockposition.text = curLock.lockposition
     
        var curlocktime = utc() - GlobalSessionUser.shared.srvDuration        
        labelpassword.text = GlobalSessionUser.shared.getCurtimePassword(curLock.lockdeviceid,curtime: curlocktime)
       
       
        
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
