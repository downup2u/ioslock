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
    @IBOutlet weak var lockidField: UILabel!
    @IBOutlet weak var lockpwdField: UITextField!
    @IBOutlet weak var lockPositionField: UILabel!

    
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
        lockidField.text = curLock.lockdeviceid
        lockPositionField.text = curLock.lockposition
//        
        addButtonCorner_OK(btnOK)
        // Do any additional setup after loading the view.
        var navigationBarViewRect:CGRect = CGRectMake(0.0,0.0,0.0,0.0)
        keyboard = KeyboardManager(controller: self,navRect:navigationBarViewRect)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var keyboard:KeyboardManager!
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        keyboard.enableKeyboardManger()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        keyboard.disableKeyboardManager()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        keyboard.endEditing()
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
        if(lockpwdField.text != curLock.lockpasswd){
            showError("","锁具密码不对")
            return
        }
        var msgReq = IteasyNfclock.PkgLockLogOffReq.builder()
        msgReq.lockuuid = curLock.lockuuid
        var msgReply = IteasyNfclock.PkgLockLogOffReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                showSuccess("","注销成功")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else{
                showError("",msgReply.err)

            }
        })
        
    }

}
