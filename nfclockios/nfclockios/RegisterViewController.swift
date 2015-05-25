//
//  RegisterViewController.swift
//  WorkTest
//
//  Created by wxqdev on 14-9-29.
//  Copyright (c) 2014年 wxqdev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var viewLoginBk: UIView!
  
    @IBOutlet weak var phonenumberField: UITextField!
    @IBOutlet weak var authcodeField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoginBk.layer.borderColor = UIColor.colorWithHex("#E5E5E5")?.CGColor
        viewLoginBk.layer.borderWidth = 1
        viewLoginBk.layer.cornerRadius = 6
        viewLoginBk.layer.masksToBounds = true

        addPaddedLeftView(self.phonenumberField,UIImage(named: "sj")!,UIImage(named: "sj_02")!)
        addPaddedLeftView(self.authcodeField,UIImage(named: "dx")!,UIImage(named: "dx_02")!)
        addPaddedLeftView(self.passwordField,UIImage(named: "mima")!,UIImage(named: "mima_02")!)
        addPaddedLeftView(self.userField,UIImage(named: "mima")!,UIImage(named: "mima_02")!)

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
        if self.phonenumberField.text.isEmpty
        {
            showError("",NSLocalizedString("PhonenumberNotNull", comment:"手机号码不能为空"))
            return
        }
        
        var msgReq = IteasyNfclock.PkgUserGetAuthReq.builder()
        msgReq.phonenumber = phonenumberField.text
        msgReq.authtype = IteasyNfclock.EnAuthType.AuthTypeRegister
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

    @IBAction func btnRegisterOK(sender: AnyObject) {
        if self.phonenumberField.text.isEmpty
        {
            showError("",NSLocalizedString("PhonenumberNotNull", comment:"手机号码不能为空"))
             return
        }

        if self.authcodeField.text.isEmpty
        {
            showError("",NSLocalizedString("AuthCodeNotNull", comment:"验证码不能为空"))
            return
        }
        if self.passwordField.text.isEmpty
        {
            showError("",NSLocalizedString("PassowrdNotNull", comment:"密码不能为空"))
            return
        }
        if self.userField.text.isEmpty
        {
            showError("",NSLocalizedString("UsernameNotNull", comment:"请输入真实用户姓名"))
            return
        }
        var msgReq = IteasyNfclock.PkgUserAuthSetReq.builder()
        msgReq.phonenumber = self.phonenumberField.text
        msgReq.authtype = IteasyNfclock.EnAuthType.AuthTypeRegister
        msgReq.authcode = self.authcodeField.text
        msgReq.password = self.passwordField.text
        msgReq.truename = self.userField.text
        var msgReply = IteasyNfclock.PkgUserAuthSetReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                Globals.shared.setCheckPassword(Globals.shared.getCheckPassword(), Username: self.phonenumberField.text, Password: self.passwordField.text)
                let successView  = self.storyboard?.instantiateViewControllerWithIdentifier("successview") as! SuccessViewController
                self.navigationController?.pushViewController(successView, animated: true)
                
            }
            else{
                showError("",msgReply.err)
            }
        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /**/

    // MARK: - Navigation
    var realname:String = ""
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        if(segue.destinationViewController is ActiveAccountViewController){
//            var dvc:ActiveAccountViewController = segue.destinationViewController as ActiveAccountViewController
//            dvc.phonenumber = phonenumberField.text
//        }
//        else if(segue.destinationViewController is FinishRegisterViewController){
//            var dvc:FinishRegisterViewController = segue.destinationViewController as FinishRegisterViewController
//            dvc.phonenumber = phonenumberField.text
//            dvc.oldpassword = invitioncodeField.text
//            dvc.realname = self.realname
//        }
    }

}
