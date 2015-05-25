//
//  LoginViewController.swift
//  WorkTest
//
//  Created by wxqdev on 14-9-29.
//  Copyright (c) 2014年 wxqdev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var accoutField: UITextField!
    @IBOutlet weak var passwordField: UITextField!


    @IBAction func onClickLogin(sender: AnyObject) {
        if(count(accoutField.text) == 0){
            var errString:String = "账号不能为空"
            showError("",errString)
            return
        }
        if(count(passwordField.text) == 0){
            var errString:String = "密码不能为空"
            showError("",errString)
            return
        }
        var msgReq = IteasyNfclock.PkgUserLoginReq.builder()
        msgReq.logintype = IteasyNfclock.EnLoginType.LoginTypePhonenumber
        msgReq.phonenumber = accoutField.text
        msgReq.userpassword = passwordField.text
        var msgReply = IteasyNfclock.PkgUserLoginReply.builder()

        GlobalSessionUser.shared.phonenumber = msgReq.phonenumber
        GlobalSessionUser.shared.passwordsaved = msgReq.userpassword
        getLocalMsg(msgReq,msgReply,{
                if(msgReply.issuccess){
                    Globals.shared.setCheckPassword(self.isRememberedMe, Username: self.accoutField.text, Password: self.passwordField.text)
                    
                    GlobalSessionUser.shared.truename = msgReply.truename
                    GlobalSessionUser.shared.phonenumber = msgReply.phonenumber
                    GlobalSessionUser.shared.idcardnumber = msgReply.idcardnumber
                    GlobalSessionUser.shared.registertime = msgReply.registertime
                    GlobalSessionUser.shared.islogined = true
                    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDel.setAppviewAsRootView()
                    
                    let now = utc()
                    if let srv = moment(msgReply.cursrvtime,"yyyy-MM-dd HH:mm:ss",
                        timeZone:NSTimeZone(abbreviation: "UTC")!){
                            GlobalSessionUser.shared.srvDuration = now - srv
                    }
                   
                    println("why cannot find:\(msgReply.cursrvtime),now:\(now)")
                    
                    
                }
                else{
                    showError("",msgReply.err)

                    return
                }
        })
    }
    

    var keyboard:KeyboardManager!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        addButtonCorner_OK(loginButton)
        addButtonCorner_OK(registerButton)
        
        loginButton.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#2495DD")), forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        registerButton.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#4773DE")), forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.colorWithHex("#345E91"), forState: UIControlState.Normal)
        
        addPaddedLeftView(self.passwordField!,UIImage(named: "mima")!,UIImage(named: "mima_02")!)
        addPaddedLeftView(self.accoutField!,UIImage(named: "zh")!,UIImage(named: "zh")!)
  
        addButtonCheckBox(remembermeButton,UIImage(named: "jzml")!,UIImage(named: "jzml_02")!)
        
        self.isRememberedMe = Globals.shared.getCheckPassword()
        remembermeButton.selected = isRememberedMe
        
        if(self.isRememberedMe){
            accoutField.text = Globals.shared.getDefaultUserName()
            passwordField.text = Globals.shared.getDefaultPassword()
        }
        
        var navigationBarViewRect:CGRect = CGRectMake(0.0,0.0,0.0,0.0)
        keyboard = KeyboardManager(controller: self,navRect:navigationBarViewRect)
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)
        self.navigationController?.navigationBarHidden = true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onDataCallback(notification: NSNotification){
       

    }
    
    override func viewDidAppear(animated: Bool)
    {
        accoutField.text = Globals.shared.getDefaultUserName()
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
    
   
 
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var remembermeButton: UIButton!

    @IBOutlet weak var forgotpasswordButton: UIButton!
    
    
    func didClickPasswordReveal() {
        passwordField.secureTextEntry = !passwordField.secureTextEntry
    }


    
    var isRememberedMe = false
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func onClickRememberMe(sender: AnyObject) {
        isRememberedMe = !isRememberedMe
        remembermeButton.selected = isRememberedMe
      //  Globals.shared.setRememberMe(isRememberedMe)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
