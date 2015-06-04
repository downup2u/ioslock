//
//  userDelegate.swift
//  nfclockios
//
//  Created by wxqdev on 15/5/10.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import Foundation

protocol UserChooseDelegate :class{
    func onUserChoosed(useruserlist:Array<String>)
}
protocol OfflineTimeChooseDelegate :class{
    func onOfflineChoosed(offlinetime:Int)
}
protocol ScanQRCodeDelegate :class{
    func onScanedText(txt:String)
}