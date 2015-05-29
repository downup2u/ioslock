//
//  GlobalSessionUser.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-23.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import Foundation

class GlobalSessionUser {
    class var shared : GlobalSessionUser {
        
        struct Static {
            static let instance : GlobalSessionUser = GlobalSessionUser()
        }
        
        return Static.instance
    }
    
    var srvDuration = Duration(value: 0)

    
    var ownerLockArray = [IteasyNfclock.db_lock()]
    var otherLockArray = [IteasyNfclock.db_lock()]
    var userArray = [IteasyNfclock.PkgUserUsers()]
    var userSelArray = [IteasyNfclock.db_lock_user_user()]
    var lockpasswordMap = Dictionary<String,Array<IteasyNfclock.PkgLockPassword>>()
    
    var userid:String = ""
    
    func getUserUserName(useruuid:String)->String{
        for usr in userArray{
            if usr.dbLockUserUser.relateduseruuid == useruuid{
                return "\(usr.dbLockUserUser.departmentname)/\(usr.dbLockUserUser.truename)"
            }
        }
        //if(useruuid == "")
        return truename
    }
    func onGetLocks(msgPkgSrvPushLocks:IteasyNfclock.PkgSrvPushLocksBuilder){
        self.ownerLockArray.removeAll(keepCapacity: false)
        self.otherLockArray.removeAll(keepCapacity: false)
        for lockinfo in msgPkgSrvPushLocks.ownerlocklist{
            self.ownerLockArray.append(lockinfo)
        }
        for lockinfo in msgPkgSrvPushLocks.otherlocklist{
            self.otherLockArray.append(lockinfo)
        }
        
//        dispatch_async(dispatch_get_main_queue(), {
//            println("onOwnerGetLocks:\(self.ownerLockArray.count),\(self.otherLockArray.count)")
//            NSNotificationCenter.defaultCenter().postNotificationName("onOwnerLockCallback", object: nil)
//        })
        dispatch_async(dispatch_get_main_queue(), {
            println("onGetLocks:\(self.ownerLockArray.count),\(self.otherLockArray.count)")
            NSNotificationCenter.defaultCenter().postNotificationName("onLockCallback", object: nil)
        })

        
    }
    
    func onGetUsers(msgPkgSrvPushUsers:IteasyNfclock.PkgSrvPushUserUsersBuilder){
        self.userArray.removeAll(keepCapacity: false)
        self.userSelArray.removeAll(keepCapacity: false)
        for userinfo in msgPkgSrvPushUsers.userlist{
            self.userArray.append(userinfo)
            if userinfo.userusertype.rawValue == IteasyNfclock.EnUserUserType.UserUserTypeAdded.rawValue{
                self.userSelArray.append(userinfo.dbLockUserUser)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            NSNotificationCenter.defaultCenter().postNotificationName("onUserCallback", object: nil)
        })
        
    }
    
    func onGetLockPassword(msgLockPassword:IteasyNfclock.PkgSrvPushLockListPasswordListBuilder){
        self.lockpasswordMap.removeAll(keepCapacity: false)
        for pwdlist in msgLockPassword.locklistpasswordlist{
            var deviceid = pwdlist.lockdeviceid
            var arraypwd = pwdlist.lockpasswordlist
            self.lockpasswordMap[deviceid] = arraypwd
           // println("onGetLockPassword:\(deviceid),\(arraypwd)")
        }

    }
    
    func getCurtimePassword(deviceid:String,curtime:Moment) -> String{
        
     //   println("getCurtimePassword:\(deviceid),curtime:\(curtime)")
        var password = ""
        if let arr = self.lockpasswordMap[deviceid] {
            if  arr.count > 1{
                for var i = 0;i < arr.count - 1; i++ {
                    var starttime = moment(arr[i].timestamp,"yyyy-MM-dd HH:mm:ss",timeZone:NSTimeZone(abbreviation: "UTC")!)
                    var endtime = moment(arr[i+1].timestamp,"yyyy-MM-dd HH:mm:ss",timeZone:NSTimeZone(abbreviation: "UTC")!)
                    if(curtime >= starttime && curtime < endtime){
                        return arr[i].lockpassword
                    }
                }
            }
        }
        
        return password
    }
    
    var islogined = false
    var phonenumber = ""
    var truename = ""
    var idcardnumber = ""
    var passwordsaved = ""
    var registertime = ""
    var offlinetime = 5
   // var
    
}