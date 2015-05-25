//
//  DoorUserAddUserViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-7.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class DoorUserAddUserViewController: UIViewController {

    var keyboard:KeyboardManager!
    
    @IBOutlet weak var viewLoginBk: UIView!
    @IBOutlet weak var phonenumberField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var departmentField: UITextField!

    @IBOutlet weak var btnOK: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoginBk.layer.borderColor = UIColor.colorWithHex("#E5E5E5")?.CGColor
        viewLoginBk.layer.borderWidth = 1
        viewLoginBk.layer.cornerRadius = 6
        viewLoginBk.layer.masksToBounds = true
        
        addPaddedLeftView(self.phonenumberField,UIImage(named: "sj")!,UIImage(named: "sj")!)
        addPaddedLeftView(self.nameField,UIImage(named: "ren")!,UIImage(named: "ren")!)
        addPaddedLeftView(self.departmentField,UIImage(named: "men")!,UIImage(named: "men")!)
        

        addButtonCorner_OK(btnOK)
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)
        var navigationBarViewRect:CGRect = CGRectMake(0.0,0.0,0.0,0.0)
        keyboard = KeyboardManager(controller: self,navRect:navigationBarViewRect)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onDataCallback(notification: NSNotification){
        println("onDataCallback->current thread = \(NSThread.currentThread())");
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickOK(sender: AnyObject) {
        var msgReq = IteasyNfclock.PkgUserAddReq.builder()
        var msgUser = IteasyNfclock.db_lock_user_user.builder()
        msgUser.truename = nameField.text
        msgUser.userphonenumber = phonenumberField.text
        msgUser.departmentname = departmentField.text
        msgReq.user = msgUser.build()

        var msgReply = IteasyNfclock.PkgUserAddReply.builder()
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
    

}
