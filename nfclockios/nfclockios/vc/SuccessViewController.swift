//
//  SuccessViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/8.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    var txtTitle = "注册成功"
    var txtLabel = "注册成功!"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = txtTitle
        labelTxt.text = txtLabel
        
        addButtonCorner_OK(btnOK)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var labelTxt: UILabel!
    @IBOutlet weak var btnOK: UIButton!

    @IBAction func onClickBtnOK(sender: AnyObject) {
         self.navigationController?.popToRootViewControllerAnimated(true)
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
