//
//  useruserTableViewCell.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/9.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class useruserTableViewCell: SWTableViewCell {

    var pkgUserUser = IteasyNfclock.PkgUserUsers()
    @IBOutlet weak var labelDepartment: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhonenumber: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var btnInfo: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        

    }
    @IBAction func onClickInfo(sender: AnyObject) {
        showWarning("", pkgUserUser.infotxt)
    }
    
    func setusers(){
        if let useruser = pkgUserUser.dbLockUserUser {
            labelDepartment.text = useruser.departmentname
            labelName.text = useruser.truename
            labelPhonenumber.text = useruser.userphonenumber
        }
        
        var rightbtns = NSMutableArray()
        if pkgUserUser.infotxt == ""{
            btnInfo.hidden = true
        }
        else{
            btnInfo.hidden = false
        }
        if pkgUserUser.userusertype == IteasyNfclock.EnUserUserType.UserUserTypeEmpty{
            //未注册，邀请
            imgStatus.image = UIImage(named:"No_zc")
            rightbtns.sw_addUtilityButtonWithColor(UIColor.redColor(), icon: UIImage(named: "invite"))
        }
        else if pkgUserUser.userusertype == IteasyNfclock.EnUserUserType.UserUserTypeRegister{
            //已注册，添加
            imgStatus.image = UIImage(named:"y_tj")
            rightbtns.sw_addUtilityButtonWithColor(UIColor.redColor(), icon: UIImage(named: "tj_sqm"))
        }
        else if pkgUserUser.userusertype == IteasyNfclock.EnUserUserType.UserUserTypeAdded{
            //已添加
            imgStatus.image = UIImage(named:"y_zc")
        }
        //删除
        rightbtns.sw_addUtilityButtonWithColor(UIColor.redColor(), icon: UIImage(named: "Delete"))
        
        setRightUtilityButtons(rightbtns as [AnyObject], withButtonWidth: 60)
    }
}
