//
//  LockNewTableViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-2.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class LockNewTableViewController: FormViewController, FormViewControllerDelegate {

    struct Static {
        static let nameTag = "nameTag"
        static let passwordTag = "passwordTag"
        static let locationNameTag = "locationNameTag"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: .Bordered, target: self, action: "onOK:")
    }
    func onOK(_: UIBarButtonItem!) {
        
        let message = self.form.formValues().description
        
        let alert: UIAlertView = UIAlertView(title: "Form output", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        alert.show()
    }
    private func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "新锁注册"
        
        let section1 = FormSectionDescriptor()
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.nameTag, rowType: .Name, title: "锁具ID")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "新锁具ID", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.passwordTag, rowType: .Password, title: "锁具口令")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "输入锁具口令", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
       // let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.locationNameTag, rowType: .Name, title: "锁具位置")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "例：财务部", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        form.sections = [section1]
        
        self.form = form
    }
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
//        if rowDescriptor.tag == Static.button {
//            self.view.endEditing(true)
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}
