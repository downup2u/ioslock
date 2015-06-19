//
//  OCWrap.m
//  OCWrap
//
//  Created by wxqdev on 14-11-12.
//  Copyright (c) 2014年 task.iteasysoft.com. All rights reserved.
//

#import "OCWrap.h"
#include "cppwrap.h"
//#import "nfclockios-swift.h"

@implementation OCWrap

void onclient_msg(boost::shared_ptr<std::string> pMsgReply){
  //  swiftocobj*ob = [swiftocobj new];
    NSString*msgHex = [[NSString alloc] initWithCString:pMsgReply->c_str() encoding:NSASCIIStringEncoding];
  //  [ob onSrvMessage:msgHex]
    [[NSNotificationCenter defaultCenter]postNotificationName:@"onSrvMessage" object:msgHex];
    NSLog(@"onclient_msg：current thread = %@", [NSThread currentThread]);
}

+(void)initModule:(NSString*)args
{
    std::string sargs([args cStringUsingEncoding:NSASCIIStringEncoding]);
    _initModule(sargs,boost::bind(onclient_msg,_1));
}

+(NSString*)sendMessage:(NSString*)sMsg
{
    std::string strIn([sMsg cStringUsingEncoding:NSASCIIStringEncoding]);
    std::string strOut;
    
    strOut = _sendMessage(strIn);
    return [[NSString alloc] initWithCString:strOut.c_str() encoding:NSASCIIStringEncoding];
    
}

+(NSString*)sendMessageWithHander:(NSString*)sMsg handler:(MsgHandler)handler
{
    std::string strIn([sMsg cStringUsingEncoding:NSASCIIStringEncoding]);
    std::string strOut;
    
    strOut = _sendMessage(strIn,[=](boost::shared_ptr<std::string> pMsgReply){
        NSString*msgHex = [[NSString alloc] initWithCString:pMsgReply->c_str() encoding:NSASCIIStringEncoding];
        handler(msgHex);
        
    });
    return [[NSString alloc] initWithCString:strOut.c_str() encoding:NSASCIIStringEncoding];

}

+(void)stopModule
{
  _stopModule();
}

@end
