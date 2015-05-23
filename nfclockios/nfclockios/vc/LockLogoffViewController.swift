//
//  LockLogoffViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-30.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class LockLogoffViewController: UIViewController {

    var curLock = IteasyNfclock.db_lock()
    @IBOutlet weak var viewLoginBk: UIView!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lockidField: UITextField!
    @IBOutlet weak var lockpwdField: UITextField!
    @IBOutlet weak var lockPositionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoginBk.layer.borderColor = UIColor.colorWithHex("#E5E5E5")?.CGColor
        viewLoginBk.layer.borderWidth = 1
        viewLoginBk.layer.cornerRadius = 6
        viewLoginBk.layer.masksToBounds = true
        
//        addPaddedLeftView(self.lockidField,UIImage(named: "sj")!,UIImage(named: "sj_02")!)
//        addPaddedLeftView(self.lockpwdField,UIImage(named: "dx")!,UIImage(named: "dx_02")!)
//        addPaddedLeftView(self.lockPositionField,UIImage(named: "dx")!,UIImage(named: "dx_02")!)
//        
//        
        addButtonCorner_OK(btnOK)
        // Do any additional setup after loading the view.
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
    @IBAction func onClickLogoffLock(sender: AnyObject) {
        var msgReq = IteasyNfclock.PkgLockLogOffReq.builder()
        msgReq.lockuuid = curLock.lockuuid
        var msgReply = IteasyNfclock.PkgLockLogOffReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                //OK
            }
        })
        
    }

}
