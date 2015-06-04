//
//  AppDelegate.swift
//  nfclockios
//
//  Created by wxqdev on 15-3-28.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
       // TSMessage.addCustomDesignFromFileWithName("AlternativeDesign.json")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onSrvMessage:", name: "onSrvMessage", object: nil)
        // Override point for customization after application launch.
        var sArgs:String = "nfclockclient --srvuri=ws://192.168.1.199:9002 --connectinterval=5 --autoconnect=true"
      //  var sArgs:String = "nfclockclient --srvuri=ws://nfclock.iteasysoft.com --connectinterval=5 --autoconnect=true"
        OCWrap.initModule(sArgs)
        
        setLoginviewAsRootView()
      //  println("application->current thread = \(NSThread.currentThread())");
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
         NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func onSrvMessage(notification: NSNotification){
        var msgHexData: String = notification.object as! String
        var msgReply = Comminternal.PkgMsg.builder()
       
        let hexData = hexStringToData(msgHexData)
//        var buffer = [UInt8](count:hexData.length, repeatedValue:0)
//        hexData.getBytes(&buffer, length:hexData.length)
        msgReply.mergeFromData(hexData)
       // println("msgHexData->current thread = \(NSThread.currentThread())");
    //    println("msgHexData:\(msgHexData)")

        dispatch_sync(dispatch_get_main_queue(), {
            if msgReply.enmsgstatuscode == Comminternal.PkgMsg.EnMsgStatusCode.MsgStatusnone{
                if(msgReply.resmsgtype == "iteasy_nfclock.PkgSrvPushLocks"){
                    var msgReply2 = IteasyNfclock.PkgSrvPushLocks.builder()
                    let hexData = hexStringToData(msgReply.resmsgdata)
                    msgReply2.mergeFromData(hexData)
                    GlobalSessionUser.shared.onGetLocks(msgReply2)
                }
                else if(msgReply.resmsgtype=="iteasy_nfclock.PkgSrvPushUserUsers"){
                    var msgReply2 = IteasyNfclock.PkgSrvPushUserUsers.builder()
                    let hexData = hexStringToData(msgReply.resmsgdata)
                    msgReply2.mergeFromData(hexData)
                    GlobalSessionUser.shared.onGetUsers(msgReply2)
                    
                }
                else if(msgReply.resmsgtype=="iteasy_nfclock.PkgSrvPushLockListPasswordList"){
                    var msgReply2 = IteasyNfclock.PkgSrvPushLockListPasswordList.builder()
                    let hexData = hexStringToData(msgReply.resmsgdata)
                    msgReply2.mergeFromData(hexData)
                    GlobalSessionUser.shared.onGetLockPassword(msgReply2)
                    
                }
                else{
                    NSNotificationCenter.defaultCenter().postNotificationName("onDataCallback", object: notification.object)
                }
            }
            else{
                if(msgReply.enmsgstatuscode == Comminternal.PkgMsg.EnMsgStatusCode.MsgConnected){
                    if(msgReply.issuc){
                        showSuccess("", "连接服务器成功")
                    }
                    else {
                        showError("", "连接服务器失败")
                    }
                
                    if(msgReply.issuc && GlobalSessionUser.shared.islogined){
                        var msgReq = IteasyNfclock.PkgUserLoginReq.builder()
                        msgReq.logintype = IteasyNfclock.EnLoginType.LoginTypePhonenumber
                        msgReq.phonenumber = GlobalSessionUser.shared.phonenumber
                        msgReq.userpassword = GlobalSessionUser.shared.passwordsaved
                        var msgReply = IteasyNfclock.PkgUserLoginReply.builder()
                        getLocalMsg(msgReq,msgReply,{
                            if(msgReply.issuccess){
                                GlobalSessionUser.shared.truename = msgReply.truename
                                GlobalSessionUser.shared.phonenumber = msgReply.phonenumber
                                GlobalSessionUser.shared.idcardnumber = msgReply.idcardnumber
                                GlobalSessionUser.shared.registertime = msgReply.registertime
                                GlobalSessionUser.shared.islogined = true
                                GlobalSessionUser.shared.offlinetime = Int(msgReply.offlinetime)
                            }
                        })
                    }
                }
                
            }
        })
            
}
    
    
    func setAppviewAsRootView(){
       
        var storyBoardTask = UIStoryboard(name:"lock",bundle:nil)
        var AppNav = storyBoardTask.instantiateViewControllerWithIdentifier("mainAppNav") as! MyUITabBarController
        
        self.window!.rootViewController = AppNav
    }
    func setLoginviewAsRootView(){
        
        var storyBoardTask = UIStoryboard(name:"Main",bundle:nil)
        var AppNav = storyBoardTask.instantiateViewControllerWithIdentifier("loginroot") as! RootNavigationViewController
       
        self.window!.rootViewController = AppNav
    }
}

