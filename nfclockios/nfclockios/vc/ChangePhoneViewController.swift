//
//  ChangePhoneViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/5.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class ChangePhoneViewController: UIViewController {

    var keyboard:KeyboardManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoginBk.layer.borderColor = UIColor.colorWithHex("#E5E5E5")?.CGColor
        viewLoginBk.layer.borderWidth = 1
        viewLoginBk.layer.cornerRadius = 6
        viewLoginBk.layer.masksToBounds = true
        
        addPaddedLeftView(self.fieldPhone,UIImage(named: "sj")!,UIImage(named: "sj_02")!)
        addPaddedLeftView(self.fieldAuthcode,UIImage(named: "dx")!,UIImage(named: "dx_02")!)

        
       
        let revealButton = addSecureTextSwitcher(self.fieldAuthcode!,UIImage(named: "yzm")!,UIImage(named: "yzm_02")!,80)
        revealButton.addTarget(self, action: "sendAuthcode", forControlEvents: UIControlEvents.TouchUpInside)
        addButtonCorner(btnOK)
        var navigationBarViewRect:CGRect = CGRectMake(0.0,0.0,0.0,0.0)
        keyboard = KeyboardManager(controller: self,navRect:navigationBarViewRect)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var viewLoginBk: UIView!
    @IBOutlet weak var fieldPhone: UITextField!
    @IBOutlet weak var fieldAuthcode: UITextField!
    @IBOutlet weak var btnOK: UIButton!

    @IBAction func onClickOK(sender: AnyObject) {
        if self.fieldPhone.text.isEmpty
        {
            showError("",NSLocalizedString("PhonenumberNotNull", comment:"手机号码不能为空"))
            return
        }
        
        if self.fieldAuthcode.text.isEmpty
        {
            showError("",NSLocalizedString("AuthCodeNotNull", comment:"验证码不能为空"))
            return
        }
        var msgReq = IteasyNfclock.PkgUserResetPhonenumberReq.builder()
        msgReq.phonenumber = fieldPhone.text
        msgReq.authcode = fieldAuthcode.text
        var msgReply = IteasyNfclock.PkgUserResetPhonenumberReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                
            }
            else{
                showError("",msgReply.err)
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
    
    func sendAuthcode() {
        if self.fieldPhone.text.isEmpty
        {
            showError("", NSLocalizedString("PhonenumberNotNull", comment:"手机号码不能为空"))
            return
        }
        
        var msgReq = IteasyNfclock.PkgUserGetAuthReq.builder()
        msgReq.phonenumber = fieldPhone.text
        msgReq.authtype = IteasyNfclock.EnAuthType.AuthTypeResetPhonenumber
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
}
