//
//  DoorMyProfileViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-2.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class DoorMyProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,OfflineTimeChooseDelegate ,ChangePhonumberDelegate{

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var labelName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.sectionHeaderHeight = 30
       
        //addButtonCorner_OK(btnExit)
        labelName.text = GlobalSessionUser.shared.truename
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onOfflineChoosed(offlinetime:Int){
        var msgReq = IteasyNfclock.PkgUserSetOfflineTimeReq.builder()
        msgReq.offlinetime = Int32(offlinetime)
        var msgReply = IteasyNfclock.PkgUserSetOfflineTimeReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                GlobalSessionUser.shared.offlinetime = offlinetime
                showSuccess("","设置默认离网时间成功")
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            else{
                showError("",msgReply.err)
            }
        })

        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{

        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
 
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("cellNext", forIndexPath: indexPath) as! UITableViewCell
                cell.imageView?.image = UIImage(named: "sj")!
                cell.textLabel?.text = "注册手机号"
                var str = GlobalSessionUser.shared.phonenumber
                var attribute = NSMutableAttributedString(string: str)
                cell.detailTextLabel?.attributedText = attribute
            }
            if indexPath.row == 1 {
                
                cell = tableView.dequeueReusableCellWithIdentifier("cellNext", forIndexPath: indexPath) as! UITableViewCell
                cell.imageView?.image  = UIImage(named: "mima")!
                cell.textLabel?.text = "登录密码"
                var str = "修改密码"
                var attribute = NSMutableAttributedString(string: str)
                cell.detailTextLabel?.attributedText = attribute

            }


        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("cellNext", forIndexPath: indexPath) as! UITableViewCell
                cell.imageView?.image  = UIImage(named: "sq_gm")!
                cell.textLabel?.text = "授权人管理"
                var str = ""
                var attribute = NSMutableAttributedString(string: str)
                cell.detailTextLabel?.attributedText = attribute
            }
            if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier("cellNext", forIndexPath: indexPath) as! UITableViewCell
                cell.imageView?.image  = UIImage(named: "zc_sm")!
                cell.textLabel?.text = "离网时间"
                var str = "\(GlobalSessionUser.shared.offlinetime)分钟"
                var attribute = NSMutableAttributedString(string: str)
                cell.detailTextLabel?.attributedText = attribute
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("cellNext", forIndexPath: indexPath) as! UITableViewCell
                cell.textLabel?.text = "关于软件"
                cell.imageView?.image  = UIImage(named: "About")!
                var str = ""
                var attribute = NSMutableAttributedString(string: str)
                cell.detailTextLabel?.attributedText = attribute
            }
            if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier("cellNext", forIndexPath: indexPath) as! UITableViewCell
                cell.imageView?.image  = UIImage(named: "zc_sj")!
                cell.textLabel?.text = "注册时间"
                var str = GlobalSessionUser.shared.registertime
                var attribute = NSMutableAttributedString(string: str)
                cell.detailTextLabel?.attributedText = attribute
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func onPhonenumberChanged(phonenumber:String){
        self.tableView.reloadData()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if(indexPath.section == 0){
            if(indexPath.row == 0){//修改手机号码
                var storyBoard = UIStoryboard(name:"lock",bundle:nil)
                var dvc = storyBoard.instantiateViewControllerWithIdentifier("changephonenumber") as! ChangePhoneViewController
                dvc.delegate = self
                self.navigationController?.pushViewController(dvc,animated: true)
            }
            else if(indexPath.row == 1)
            {//修改登录密码
                var storyBoard = UIStoryboard(name:"lock",bundle:nil)
                var dvc = storyBoard.instantiateViewControllerWithIdentifier("changepwd") as! MyInfoUpdatePasswordViewController
                
                self.navigationController?.pushViewController(dvc,animated: true)
            }
          
        }
        else if(indexPath.section == 1){
            //授权人管理
            if(indexPath.row == 0){//
                var storyBoard = UIStoryboard(name:"lock",bundle:nil)
                var dvc = storyBoard.instantiateViewControllerWithIdentifier("myprofilemember") as! MyProfileMemberManagerViewController
                
                self.navigationController?.pushViewController(dvc,animated: true)
            }
            if(indexPath.row == 1){
                //离网时间
//                var storyBoard = UIStoryboard(name:"lock",bundle:nil)
                var dvc = self.storyboard?.instantiateViewControllerWithIdentifier("setofflinetime") as! SetOfflineTimeViewController
                dvc.defaultofflinetime = GlobalSessionUser.shared.offlinetime
                dvc.delegate = self
                self.navigationController?.pushViewController(dvc,animated: true)
            }
            
        }
        else if(indexPath.section == 2){
            if(indexPath.row == 0){//
                var dvc = self.storyboard?.instantiateViewControllerWithIdentifier("aboutview") as! AboutViewController
                self.navigationController?.pushViewController(dvc,animated: true)
                //关于
            }
        }
        
    }
    @IBAction func onClickExit(sender: AnyObject) {
        var msgReq = IteasyNfclock.PkgLogoutReq.builder()
        msgReq.phoneversion = "ios"
        var msgReply = IteasyNfclock.PkgLogoutReply.builder()
        getLocalMsg(msgReq,msgReply,{
            if(msgReply.issuccess){
                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDel.setLoginviewAsRootView()
            }
            else{
               showError("",msgReply.err)
            }
        })

    }
    
    
}
