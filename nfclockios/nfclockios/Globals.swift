//
//  Globals.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-3.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import Foundation
class Globals {
    class var shared : Globals {
        
        struct Static {
            static let instance : Globals = Globals()
        }
        
        return Static.instance
    }

    func setCheckPassword(isChecked:Bool,Username:String,Password:String){
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(isChecked, forKey: "isChecked")
        defaults.setObject(Username, forKey: "Username")
        defaults.setObject(Password, forKey: "Password")
    }
    
    func getCheckPassword()->Bool{
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var isChecked = defaults.objectForKey("isChecked") as? Bool
        if let r = isChecked {
            return r
        }
        return false
    }
    func getDefaultUserName()->String?{
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var Username = defaults.objectForKey("Username") as? String
        return Username
    }
    
    func getDefaultPassword()->String?{
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var Password = defaults.objectForKey("Password") as? String
        return Password
    }
    
}