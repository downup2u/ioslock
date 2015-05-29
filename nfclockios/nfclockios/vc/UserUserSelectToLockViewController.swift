//
//  UserUserSelectToLockViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/7.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class UserUserSelectToLockViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var delegate:UserChooseDelegate?
    var sectionUsers = Array<Array<IteasyNfclock.db_lock_user_user>>()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)
        
        var btnOK = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnOK.frame = CGRectMake(0, 0, 64, 32);
        btnOK.setImage(UIImage(named:"qd"), forState: UIControlState.Normal)
        btnOK.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnOK.addTarget(self, action: "onClickOK:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnOK)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
       
        loaddata()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onDataCallback(notification: NSNotification){
        loaddata()
        
    }

    func loaddata(){
        self.sectionUsers.removeAll(keepCapacity: false)
        var mapUsers = Dictionary<String,Array<IteasyNfclock.db_lock_user_user>>()
        for usrusr in GlobalSessionUser.shared.userSelArray{
            if let array = mapUsers[usrusr.departmentname]{
                mapUsers[usrusr.departmentname]!.append(usrusr)
            }
            else{
                var arr = Array<IteasyNfclock.db_lock_user_user>()
                arr.append(usrusr)
                mapUsers[usrusr.departmentname] = arr
            }
        }
        
        for (key,array) in mapUsers{
            self.sectionUsers.append(array)
        }

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionUsers.count
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // if(indexPath.section == 0){
        
        var cellUsr : AnyObject! = tableView.dequeueReusableCellWithIdentifier("cell")
        var useruser = self.sectionUsers[indexPath.section][indexPath.row]
      //  let useruser = GlobalSessionUser.shared.userSelArray[indexPath.row]
        
        var l1 = cellUsr.viewWithTag(101) as! UILabel
        var l2 = cellUsr.viewWithTag(102) as! UILabel
        var b1 = cellUsr.viewWithTag(100) as! UIButton
        
        l1.text = useruser.truename
        l2.text = useruser.departmentname
        
        b1.addTarget(self, action: "onSelItemClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cellUsr as! UITableViewCell
        //  }
        
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view = UIView()
        // 2.在标题视图中添加一个按钮
        var button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        // 添加标题按钮的监听方法
        button.layer.setValue(section, forKey: "sectionindex")
        button.addTarget(self, action: Selector("clickSectionDepartment:"), forControlEvents: UIControlEvents.TouchUpInside)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.setImage(UIImage(named:"gx"), forState: UIControlState.Normal)
        button.setImage(UIImage(named:"gx_02"), forState: UIControlState.Selected)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        var headerLabel = UILabel()
        headerLabel.text = sectionUsers[section][0].departmentname
        
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(headerLabel)
        view.addSubview(button)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[lab]-[btn(50)]-10-|", options: nil, metrics: nil, views:["lab":headerLabel, "btn":button]))
        
        //        button.setTitleColor(UIColor.colorWithHex("#1E90FF"), forState: UIControlState.Normal)
        //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[lab]|",options:nil, metrics:nil, views:["lab":headerLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[btn]|",options:nil, metrics:nil, views:["btn":button]))
        
        view.backgroundColor = UIColor.colorWithHex("#CAD9F8")
        
        return view
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
     
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return sectionUsers[section].count
    }


//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        return GlobalSessionUser.shared.userSelArray.count
//    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.section == 0 {
//            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//                cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryType.Checkmark ? UITableViewCellAccessoryType.None : UITableViewCellAccessoryType.Checkmark
//            }
//        }
//    }
    
    func onSelItemClicked(sender: UIButton){
        sender.selected = !sender.selected
    }
    func clickSectionDepartment(sender: UIButton){
        sender.selected = !sender.selected
        var section = sender.layer.valueForKey("sectionindex") as! Int
        let array = self.sectionUsers[section]
        for(var i = 0;i < array.count ; i++ ){
            var path = NSIndexPath(forRow:i,inSection:0)
            if let cell = tableview.cellForRowAtIndexPath(path){
                var b1 = cell.viewWithTag(100) as! UIButton
                b1.selected = sender.selected
            }
        }

    }
    func onClickOK(sender: UIViewController) {
        
        var useruserlist = Array<String>()
        for(var i = 0;i < GlobalSessionUser.shared.userSelArray.count ; i++ ){
            var path = NSIndexPath(forRow:i,inSection:0)
            if let cell = tableview.cellForRowAtIndexPath(path){
                var b1 = cell.viewWithTag(100) as! UIButton
                if(b1.selected){
                    useruserlist.append(GlobalSessionUser.shared.userSelArray[i].relateduseruuid)
                }
            }
        }
        
        if(useruserlist.count > 0){
            self.delegate?.onUserChoosed(useruserlist)
            self.navigationController?.popViewControllerAnimated(true)
        }
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
