//
//  MemberTableViewCell.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/22.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//



class MemberTableViewCell: SWTableViewCell {
    
    var useruser = IteasyNfclock.db_lock_user_user()
    @IBOutlet weak var labelDepartment: UILabel!
    @IBOutlet weak var labelName: UILabel!

}