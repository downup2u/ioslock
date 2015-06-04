//
//  protomsgutil.swift
//  nfclockios
//
//  Created by wxqdev on 15-3-31.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import Foundation


func hexStringFromData(data: NSData) -> String {
    var hexString = NSMutableString()
    var buffer = [UInt8](count:data.length, repeatedValue:0)
    data.getBytes(&buffer, length:data.length)
    for var i=0; i<buffer.count; i++ {
        hexString.appendFormat("%02x", buffer[i])
    }
    return hexString as String
}


func hexStringToData (string: String) -> NSData {
    // Based on: http://stackoverflow.com/a/2505561/313633
    var data = NSMutableData()
    var temp = ""
    for char in string {
        temp+=String(char)
        if(count(temp) == 2) {
            let scanner = NSScanner(string: temp)
            var value: CUnsignedInt = 0
            scanner.scanHexInt(&value)
            data.appendBytes(&value, length: 1)
            temp = ""
        }
        
    }
    return data as NSData
}

func getIntelMsgString(typename:String,msgReq:GeneratedMessage)->String{
    var msgIntel = Comminternal.PkgMsg.builder()
    var hexData = hexStringFromData(msgReq.data())
    msgIntel.msgtype = Comminternal.PkgMsg.EnMsgType.MsgReq
    msgIntel.msgdirection = Comminternal.PkgMsg.EnMsgDirection.MsgCs
    msgIntel.reqmsgtype = typename
    msgIntel.reqmsgdata = hexData
    var hexRet = hexStringFromData(msgIntel.build().data())
    return hexRet
}

func sendProtobufMsg(typename:String,msgReq:GeneratedMessage){
    var sHex = getIntelMsgString(typename,msgReq)
    OCWrap.sendMessage(sHex)
}

typealias protobufMsgResponse = (Bool,String,String) ->Void
func getResultMsg(msgHexData:String,block:protobufMsgResponse){
    var msgReply = Comminternal.PkgMsg.builder()
    
    let hexData = hexStringToData(msgHexData)
//    var buffer = [UInt8](count:hexData.length, repeatedValue:0)
//    hexData.getBytes(&buffer, length:hexData.length)
    msgReply.mergeFromData(hexData)
    
    if(msgReply.msgtype == Comminternal.PkgMsg.EnMsgType.MsgRes){
        block(true,msgReply.resmsgtype,msgReply.resmsgdata)
    }
    else{
        block(false,"","")
    }
}

typealias protobufLocalMsgResponse = (Void) ->Void
func getLocalMsg(msgReq:GeneratedMessageBuilder,msgReply:GeneratedMessageBuilder,block:protobufLocalMsgResponse){
    var cnamereq:String = msgReq.internalGetResult.classMetaType().className()
    var cnamereply:String = msgReply.internalGetResult.classMetaType().className()
    
    cnamereq =  cnamereq.replace("IteasyNfclock",withString: "iteasy_nfclock")
    cnamereply =  cnamereply.replace("IteasyNfclock",withString: "iteasy_nfclock")

    var sHex = getIntelMsgString(cnamereq,msgReq.internalGetResult)
    OCWrap.sendMessageWithHander(sHex,handler:{
        (msgHexData:String!)->Void in
        var msgPkgReply = Comminternal.PkgMsg.builder()
        
        let hexData = hexStringToData(msgHexData)
        msgPkgReply.mergeFromData(hexData)
        println("\(msgPkgReply.resmsgtype),\(cnamereply)")
        if(msgPkgReply.msgtype == Comminternal.PkgMsg.EnMsgType.MsgRes){
            let hexData2 = hexStringToData(msgPkgReply.resmsgdata)

            println("\(msgPkgReply.resmsgtype):\(hexData2)")
           
            msgReply.mergeFromData(hexData2)
            dispatch_sync(dispatch_get_main_queue(), {
                block()
            })
        }

    })

}



