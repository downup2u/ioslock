//
//  ChangeIDNumberViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/5.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class ChangeIDNumberViewController: UIViewController {

    var keyboard:KeyboardManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButtonCorner(btnOK)
        var navigationBarViewRect:CGRect = CGRectMake(0.0,0.0,0.0,0.0)
        keyboard = KeyboardManager(controller: self,navRect:navigationBarViewRect)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var fieldIDNumber: UITextField!

    @IBOutlet weak var btnOK: UIButton!
    @IBAction func onClickIDRegister(sender: AnyObject) {
        var msgReq = IteasyNfclock.PkgNameIDCardRegisterReq.builder()
        msgReq.truename = self.fieldName.text
        msgReq.idcardnumber = self.fieldIDNumber.text

        var msgReply = IteasyNfclock.PkgNameIDCardRegisterReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                showSuccess("","修改成功")
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