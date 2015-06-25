//
//  LockUpdatePasswordViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/6.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class LockUpdatePasswordViewController: UIViewController {

    var delegate:UpdateLockPasswordDelegate?
    
    var curLock = IteasyNfclock.db_lock()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoginBk.layer.borderColor = UIColor.colorWithHex("#E5E5E5")?.CGColor
        viewLoginBk.layer.borderWidth = 1
        viewLoginBk.layer.cornerRadius = 6
        viewLoginBk.layer.masksToBounds = true
        
        addButtonCorner(btnOK)
        // Do any additional setup after loading the view.
        let revealButton1 = addSecureTextSwitcher(self.fieldOldpassword!,UIImage(named: "xs")!,UIImage(named: "xs_02")!,30)
        revealButton1.addTarget(self, action: "showhidepassword1:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let revealButton2 = addSecureTextSwitcher(self.fieldNewpassword!,UIImage(named: "xs")!,UIImage(named: "xs_02")!,30)
        revealButton2.addTarget(self, action: "showhidepassword2:", forControlEvents: UIControlEvents.TouchUpInside)
        
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var viewLoginBk: UIView!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var fieldOldpassword: UITextField!
    
    @IBOutlet weak var fieldNewpassword: UITextField!
    
    @IBAction func onClickUpdateLockPassword(sender: AnyObject) {
        if self.fieldOldpassword.text.isEmpty
        {
            showError("",NSLocalizedString("OldpasswordNotNull", comment:"旧密码不能为空"))
            return
        }
        
        if self.fieldNewpassword.text.isEmpty
        {
            showError("",NSLocalizedString("NewpasswordNotNull", comment:"新密码不能为空"))
            return
        }
        if count(self.fieldNewpassword.text) < 6
        {
            showError("", "密码必须大于6位")
            return
        }
        
        var msgReq = IteasyNfclock.PkgUpdateLockPasswordReq.builder()
        msgReq.lockuuid = curLock.lockuuid
        msgReq.oldpassword = fieldOldpassword.text
        msgReq.newpassword = fieldNewpassword.text
        var msgReply = IteasyNfclock.PkgUpdateLockPasswordReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                showSuccess("","修改成功")
                self.delegate?.onUpdateLockPassword(self.fieldNewpassword.text)
                self.navigationController?.popViewControllerAnimated(true)
             }
            else{
                showError("",msgReply.err)
            }

        })

    }
    
    
    func showhidepassword1(sender: AnyObject) {
        self.fieldOldpassword.secureTextEntry = !self.fieldOldpassword.secureTextEntry
        let btn = sender as! UIButton
        btn.selected = !btn.selected
    }
    
    func showhidepassword2(sender: AnyObject) {
        self.fieldNewpassword.secureTextEntry = !self.fieldNewpassword.secureTextEntry
        let btn = sender as! UIButton
        btn.selected = !btn.selected
    }
    
}
