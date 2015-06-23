//
//  LockRegisterViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-2.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class LockRegisterViewController: UIViewController {

    var keyboard:KeyboardManager!
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
        
        addPaddedLeftView(self.lockidField,UIImage(named: "xj_id")!,UIImage(named: "xj_id")!)
        addPaddedLeftView(self.lockpwdField,UIImage(named: "xj_kl")!,UIImage(named: "xj_kl")!)
        addPaddedLeftView(self.lockPositionField,UIImage(named: "xj_wz")!,UIImage(named: "xj_wz")!)
        
        
        addButtonCorner_OK(btnOK)
        let revealButton = addSecureTextSwitcher(self.lockidField!,UIImage(named: "sm")!,UIImage(named: "sm")!,24)
        revealButton.addTarget(self, action: "onClickScanQR:", forControlEvents: UIControlEvents.TouchUpInside)

        
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)
        
        var navigationBarViewRect:CGRect = CGRectMake(0.0,0.0,0.0,0.0)
        keyboard = KeyboardManager(controller: self,navRect:navigationBarViewRect)       
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    func onDataCallback(notification: NSNotification){
        println("onDataCallback->current thread = \(NSThread.currentThread())");
    }
    @IBAction func onClickReturn(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onScanedText(txt:String!){
        self.lockidField.text = txt
    }
    
    var qrCode:QRCodeHelper?
    @IBAction func onClickScanQR(sender: AnyObject) {
       
        self.qrCode = QRCodeHelper()
        self.qrCode?.delegate = self.onScanedText
        self.qrCode?.showView(self)
       // self.navigationController?.pushViewController(dvc,animated: true)
    }
    @IBAction func onClickOK(sender: AnyObject) {
        if self.lockidField.text.isEmpty {
            showError("",NSLocalizedString("LockIdNotNull", comment:"锁ID不能为空"))
            return
        }
        
        if self.lockpwdField.text.isEmpty {
            showError("",NSLocalizedString("LockPasswordNotNull", comment:"锁密码不能为空"))
            return
        }
        
        if self.lockPositionField.text.isEmpty {
            showError("",NSLocalizedString("LockPositonNotNull", comment:"锁位置不能为空"))
            return
        }
        if count(self.lockpwdField.text) < 6
        {
            showError("", "锁密码必须大于6位")
            return
        }
        
        var msgReq = IteasyNfclock.PkgLockAddReq.builder()
        var msgLock = IteasyNfclock.db_lock.builder()
        //msgLock.lockid
        msgLock.lockdeviceid = lockidField.text
        msgLock.lockofflinetime = Int32(GlobalSessionUser.shared.offlinetime)
        msgLock.lockpasswd = lockpwdField.text
        msgLock.lockposition = lockPositionField.text
        msgReq.lock = msgLock.build()
        
        var msgReply = IteasyNfclock.PkgLockAddReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                showSuccess("","添加成功")
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            else{
              showError("",msgReply.err)
            }
        })
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
