//
//  MyInfoUpdatePasswordViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/4.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class MyInfoUpdatePasswordViewController: UIViewController {
    var keyboard:KeyboardManager!
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
        var navigationBarViewRect:CGRect = CGRectMake(0.0,0.0,0.0,0.0)
        keyboard = KeyboardManager(controller: self,navRect:navigationBarViewRect)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var viewLoginBk: UIView!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var fieldOldpassword: UITextField!

    @IBOutlet weak var fieldNewpassword: UITextField!
   
    @IBAction func onClickOK(sender: AnyObject) {
        if self.fieldOldpassword.text.isEmpty
        {
            SCLAlertView().showError("", subTitle: NSLocalizedString("OldpasswordNotNull", comment:"旧密码不能为空"), closeButtonTitle:NSLocalizedString("OK", comment:"确定"))
            return
        }
        
        if self.fieldNewpassword.text.isEmpty
        {
            SCLAlertView().showNotice("", subTitle: NSLocalizedString("NewpasswordNotNull", comment:"新密码不能为空"), closeButtonTitle:NSLocalizedString("OK", comment:"确定"))
            return
        }
        
        
        var msgReq = IteasyNfclock.PkgUserModifyPasswordReq.builder()
        msgReq.useroldpassword = fieldOldpassword.text
        msgReq.usernewpassword = fieldNewpassword.text
        var msgReply = IteasyNfclock.PkgUserModifyPasswordReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                    SCLAlertView().showSuccess("", subTitle: "修改成功", closeButtonTitle:NSLocalizedString("OK", comment:"确定"))
            }
            else{
                SCLAlertView().showError("", subTitle: msgReply.err, closeButtonTitle:NSLocalizedString("OK", comment:"确定"))
            }

        })
        

    }
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
