//
//  FindPasswordViewController.swift
//  WorkTest
//
//  Created by wxqdev on 14-10-7.
//  Copyright (c) 2014年 wxqdev. All rights reserved.
//

import UIKit

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var viewLoginBk: UIView!
    
    @IBOutlet weak var phonenumberField: UITextField!
    @IBOutlet weak var authcodeField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoginBk.layer.borderColor = UIColor.colorWithHex("#E5E5E5")?.CGColor
        viewLoginBk.layer.borderWidth = 1
        viewLoginBk.layer.cornerRadius = 6
        viewLoginBk.layer.masksToBounds = true
        
        addPaddedLeftView(self.phonenumberField,UIImage(named: "sj")!,UIImage(named: "sj_02")!)
        addPaddedLeftView(self.authcodeField,UIImage(named: "dx")!,UIImage(named: "dx_02")!)
        addPaddedLeftView(self.passwordField,UIImage(named: "mima")!,UIImage(named: "mima_02")!)
        
        addButtonCorner_OK(btnOK)
        let revealButton = addSecureTextSwitcher(self.authcodeField!,UIImage(named: "yzm")!,UIImage(named: "yzm_02")!,80)
        revealButton.addTarget(self, action: "sendAuthcode", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Do any additional setup after loading the view.
        var navigationBarViewRect:CGRect = CGRectMake(0.0,0.0,0.0,0.0)
        keyboard = KeyboardManager(controller: self,navRect:navigationBarViewRect)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)
        
        
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onDataCallback(notification: NSNotification){
        println("onDataCallback->current thread = \(NSThread.currentThread())");
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
    
    @IBOutlet weak var btnOK: UIButton!
    
    func sendAuthcode() {
        if self.phonenumberField.text.isEmpty {
            showError("", NSLocalizedString("PhonenumberNotNull", comment:"手机号码不能为空"))
            return
        }
        
        var msgReq = IteasyNfclock.PkgUserGetAuthReq.builder()
        msgReq.phonenumber = phonenumberField.text
        msgReq.authtype = IteasyNfclock.EnAuthType.AuthTypeFindPassword
        var msgReply = IteasyNfclock.PkgUserGetAuthReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                showSuccess("",NSLocalizedString("AuthcodeSendSuccess", comment:"验证码已成功发送到手机,请查收"))

            }
            else{
                showError("",msgReply.err)
            }
        })

    }
    @IBAction func onClickOK(sender: AnyObject) {
      //  self.performSegueWithIdentifier("findpasswordtoAuthSegue", sender: self)
     //   return
        if self.phonenumberField.text.isEmpty {
            showError("", NSLocalizedString("PhonenumberNotNull", comment:"手机号码不能为空"))
           return
        }
        
        if self.authcodeField.text.isEmpty
        {
            showError("", NSLocalizedString("AuthCodeNotNull", comment:"验证码不能为空"))
            return
        }
        if self.passwordField.text.isEmpty
        {
            showError("", NSLocalizedString("PassowrdNotNull", comment:"密码不能为空"))
            return
        }
        if count(self.passwordField.text) < 6
        {
            showError("", "密码必须大于6位")
            return
        }
        var msgReq = IteasyNfclock.PkgUserAuthSetReq.builder()
        msgReq.phonenumber = self.phonenumberField.text
        msgReq.authtype = IteasyNfclock.EnAuthType.AuthTypeFindPassword
        msgReq.authcode = self.authcodeField.text
        msgReq.password = self.passwordField.text
        var msgReply = IteasyNfclock.PkgUserAuthSetReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                showSuccess("", "找回密码成功")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else{
                showError("", msgReply.err)
            }

        })

 }


}
