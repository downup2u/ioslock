//
//  MyProfileViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-3-31.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class MyProfileViewController: FormViewController, FormViewControllerDelegate {

    struct Static {
        static let phoneTag = "phoneTag"
        static let loginpasswordTag = "loginpasswordTag"
        static let membermanagerTag = "membermanagerTag"
        static let limitedtimeTag = "limitedtimeTag"
        static let aboutTag = "aboutTag"
        static let registertimeTag = "registertimeTag"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "我"
        
        let section1 = FormSectionDescriptor()
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.phoneTag, rowType: .Name, title: "注册手机号")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "新锁具ID", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        
        row = FormRowDescriptor(tag: Static.loginpasswordTag, rowType: .Name, title: "登录密码")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "例：财务部", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        let section2 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.membermanagerTag, rowType: .Name, title: "成员管理")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "输入锁具口令", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        row = FormRowDescriptor(tag: Static.limitedtimeTag, rowType: .Name, title: "门禁时间自定义")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "输入锁具口令", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
       
        let section3 = FormSectionDescriptor()
        form.sections = [section1,section2,section3]
        row = FormRowDescriptor(tag: Static.membermanagerTag, rowType: .Name, title: "关于")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "输入锁具口令", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        row = FormRowDescriptor(tag: Static.limitedtimeTag, rowType: .Name, title: "注册时间")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "输入锁具口令", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)

        self.form = form
    }
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        //        if rowDescriptor.tag == Static.button {
        //            self.view.endEditing(true)
        //        }
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
