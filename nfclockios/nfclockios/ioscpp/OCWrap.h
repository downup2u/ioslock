//
//  OCWrap.h
//  OCWrap
//
//  Created by wxqdev on 14-11-12.
//  Copyright (c) 2014年 task.iteasysoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MsgHandler)(NSString* res);
@interface OCWrap : NSObject
+(void)initModule:(NSString*)args;
+(NSString*)sendMessage:(NSString*)sMsg;
+(NSString*)sendMessageWithHander:(NSString*)sMsg handler:(MsgHandler)handler;
+(void)stopModule;
@end
