//
//  SetOfflineTimeViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/28.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class SetOfflineTimeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var delegate:OfflineTimeChooseDelegate?
    var array = [5,10,15,20]
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self

        
        var btnOK = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnOK.frame = CGRectMake(0, 0, 64, 32);
        btnOK.setImage(UIImage(named:"qd"), forState: UIControlState.Normal)
        btnOK.imageView?.contentMode = UIViewContentMode.ScaleAspectFit

        btnOK.addTarget(self, action: "onClickOK:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnOK)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
     
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // if(indexPath.section == 0){
        
        var cell : AnyObject! = tableView.dequeueReusableCellWithIdentifier("cell")
        var value = self.array[indexPath.row]
        //  let useruser = GlobalSessionUser.shared.userSelArray[indexPath.row]
        
        var l1 = cell.viewWithTag(101) as! UILabel
        var b1 = cell.viewWithTag(100) as! UIButton
        b1.selected = (self.array[indexPath.row] == GlobalSessionUser.shared.offlinetime)
        l1.text = "\(value)分钟"
        b1.layer.setValue(indexPath.row, forKey: "timeindex")
        b1.addTarget(self, action: "onSelItemClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell as! UITableViewCell
        //  }
        
        
    }
   

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return array.count
    }
    
    var curSel  = 0
    
    func onSelItemClicked(sender: UIButton){
        
        self.curSel = sender.layer.valueForKey("timeindex") as! Int
        
        for(var i = 0;i < self.array.count ; i++ ){
            var path = NSIndexPath(forRow:i,inSection:0)
            if let cell = tableview.cellForRowAtIndexPath(path){
                var t = cell.viewWithTag(101)
                if let b1 = cell.viewWithTag(100) as? UIButton{
                    b1.selected = (self.curSel == i)
                }
            }
        }

        
    }
    

    func onClickOK(sender: UIViewController) {
        var msgReq = IteasyNfclock.PkgUserSetOfflineTimeReq.builder()
        msgReq.offlinetime = Int32(self.array[curSel])
        var msgReply = IteasyNfclock.PkgUserSetOfflineTimeReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                GlobalSessionUser.shared.offlinetime = self.array[self.curSel]
               showSuccess("","设置离网时间成功")
               self.navigationController?.popViewControllerAnimated(true)
               self.delegate?.onOfflineChoosed()
            }
            else{
                showError("",msgReply.err)
            }
        })

    }

}
