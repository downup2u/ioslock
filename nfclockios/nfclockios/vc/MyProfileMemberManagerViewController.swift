//
//  MyProfileMemberManagerViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-7.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class MyProfileMemberManagerViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, SWTableViewCellDelegate{
    let identifier = "cell"
    
    var userArray = [IteasyNfclock.PkgUserUsers()]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.memberstable.delegate = self
        self.memberstable.dataSource = self
        
        var nib = UINib(nibName:"useruserTableViewCell", bundle: nil)
        self.memberstable?.registerNib(nib, forCellReuseIdentifier: identifier)
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = "请输入要搜索的人员姓名"
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onUserCallback:", name: "onUserCallback", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataCallback:", name: "onDataCallback", object: nil)
       
        var btnOK = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnOK.frame = CGRectMake(0, 0, 32, 32);
        btnOK.setImage(UIImage(named:"sq_tj"), forState: UIControlState.Normal)
        btnOK.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnOK.addTarget(self, action: "onClickAdd:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnOK)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem

        loaddata()
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onUserCallback(notification: NSNotification){
        loaddata()
    }
    
    func loaddata(){
        self.userArray = GlobalSessionUser.shared.userArray
        self.memberstable.reloadData()
    }
    
    func onDataCallback(notification: NSNotification){
        println("onDataCallback->current thread = \(NSThread.currentThread())");
    }
    

    @IBAction func onClickAdd(sender: AnyObject) {
        let dvc  = self.storyboard?.instantiateViewControllerWithIdentifier("dooruseradduser") as! DoorUserAddUserViewController
        //dvc.delegate = self
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
  //  @IBOutlet weak var btnDeleteUser: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var memberstable: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? useruserTableViewCell
        var index = indexPath.row
        if(self.userArray.count > index){
           cell?.pkgUserUser = self.userArray[index]
           cell?.delegate = self
           cell?.setusers()
        }

        
        return cell!
        
        
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        if Int(self.userArray[indexPath.row].userid) == Globals.shared.userid {
//            return nil
//        }
        return indexPath
    }
    

//    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return self.userArray.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    // MARK: SWTableViewCellDelegate
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
      var btntext = ""
      let celluser = cell as! useruserTableViewCell
      if celluser.pkgUserUser.userusertype == IteasyNfclock.EnUserUserType.UserUserTypeEmpty{
        if(index == 0){
            btntext = "邀请"
            onClickBtn_Invite(celluser.pkgUserUser.dbLockUserUser)
            
        }
        else if(index == 1){
            btntext = "删除"
            onClickBtn_Delete(celluser.pkgUserUser.dbLockUserUser)
        }
      }
      else  if celluser.pkgUserUser.userusertype == IteasyNfclock.EnUserUserType.UserUserTypeRegister{
        if(index == 0){
            btntext = "添加"
            onClickBtn_Add(celluser.pkgUserUser.dbLockUserUser)
        }
        else if(index == 1){
             btntext = "删除"
            onClickBtn_Delete(celluser.pkgUserUser.dbLockUserUser)
        }
      }
      else  if celluser.pkgUserUser.userusertype == IteasyNfclock.EnUserUserType.UserUserTypeAdded{
        if(index == 0){
             btntext = "删除"
            onClickBtn_Delete(celluser.pkgUserUser.dbLockUserUser)
        }
      }

    }
    
    func onClickBtn_Invite(var useruser:IteasyNfclock.db_lock_user_user){
        var msgReq = IteasyNfclock.PkgUserUserActionReq.builder()
        msgReq.useruseruuid = useruser.uuid
        msgReq.phonenumber = useruser.userphonenumber
        msgReq.useruseractiontype = IteasyNfclock.EnUserUserActionType.UserUserActionTypeInvite
        var msgReply = IteasyNfclock.PkgUserUserActionReply.builder()
        getLocalMsg(msgReq, msgReply,{
            if(msgReply.issuccess){
                showSuccess("","邀请成功")

            }
            else{
                showError("",msgReply.err)
            }
            
        });
        
    }
    func onClickBtn_Add(var useruser:IteasyNfclock.db_lock_user_user){
        var msgReq = IteasyNfclock.PkgUserUserActionReq.builder()
        msgReq.useruseruuid = useruser.uuid
        msgReq.phonenumber = useruser.userphonenumber
        msgReq.useruseractiontype = IteasyNfclock.EnUserUserActionType.UserUserActionTypeAdd
        var msgReply = IteasyNfclock.PkgUserUserActionReply.builder()
        getLocalMsg(msgReq, msgReply,{
            if(msgReply.issuccess){
                showSuccess("","添加成功")
            }
            else{
                showError("",msgReply.err)
            }
            
        });

        
    }
    func onClickBtn_Delete(var useruser:IteasyNfclock.db_lock_user_user){
        var msgReq = IteasyNfclock.PkgUserDelReq.builder()
        msgReq.uuidlist.append(useruser.uuid)
        var msgReply = IteasyNfclock.PkgUserDelReply.builder()
        getLocalMsg(msgReq, msgReply,{
            if(msgReply.issuccess){
                showSuccess("","删除成功")
            }
            else{
                showError("",msgReply.err)
            }
            
        });

        
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searchtext = searchBar.text
        doSearch(searchBar,searchtext:searchtext)
        // keyboard.endEditing()
    }
    
    
    func searchBar(searchBar: UISearchBar,textDidChange searchText: String){
        
        doSearch(searchBar,searchtext:searchText)
    }
    
    
    func doSearch(searchBar: UISearchBar,var searchtext :String){
        
        self.userArray.removeAll(keepCapacity: true)
       
        for useruser in GlobalSessionUser.shared.userArray{
            if(searchtext == ""){
                self.userArray.append(useruser)
            }
            else{
                
                if let srange = useruser.dbLockUserUser.userphonenumber.rangeOfString(searchtext){
                    self.userArray.append(useruser)
                }
                else if let srange = useruser.dbLockUserUser.departmentname.rangeOfString(searchtext){
                    self.userArray.append(useruser)
                }
                else if let srange = useruser.dbLockUserUser.truename.rangeOfString(searchtext){
                    self.userArray.append(useruser)
                }
            }
        }
        self.memberstable.reloadData()
        
    }
}



