//
//  StringExtension.swift
//  AirQ
//
//  Created by ligh on 14/10/18.
//  Copyright (c) 2014年 Sprint. All rights reserved.
//

import Foundation

//String扩展
extension String
{
    
    //将String 转为NSString类型
    func asNSString() -> NSString
    {
        return self as NSString
    }
    
    //将String 转为Int32类型
    func intValue() -> Int32
    {
        return self.asNSString().intValue
    }
    
    //将String 转为Double类型
    func doubleValue() -> Double
    {
        return self.asNSString().doubleValue
    }
    
    //将String 转为Float类型
    func floatValue() -> Float
    {
        return self.asNSString().floatValue
    }

    //将String 转为Int类型
    func integerValue() -> Int
    {
        return self.asNSString().integerValue
    }
    
    //将String 转为Int64类型
    func longLongValue() -> Int64
    {
        return self.asNSString().longLongValue
    }
    
    //将String 转为Bool类型
    func boolValue() -> Bool
    {
        return self.asNSString().boolValue
    }
    
    
    //搜索字符最后出现的位置
    func lastRangeOfString(aString string:String) -> Range<String.Index>?
    {
        var range:Range<String.Index>? = self.rangeOfString(string, options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: NSLocale.currentLocale())

        return range
    }
    
    //判断是否包含某一个字符串
    func containsOfString(aString string:String) -> Bool
    {
        var range:Range<String.Index>? = self.rangeOfString(string)
        return range != nil
    }
    
    func replace(target: String, withString: String) -> String {
        
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func indexOf(target: String) -> Int {
        var range = self.rangeOfString(target)
        if let range = range {
            return distance(self.startIndex, range.startIndex)
        } else {
            return -1
        }
    }
    
    func indexOf(target: String, after: Int) -> Int {
        var range = self.rangeOfString(target, options: nil, range: Range(start: advance(self.startIndex, after), end: self.endIndex), locale: NSLocale.currentLocale())
        
        if let range = range {
            return distance(self.startIndex, range.startIndex)
        } else {
            return -1
        }
    }
    
    func substring(startIndex: Int, length: Int) -> String {
        var start = advance(self.startIndex, startIndex)
        var end = advance(self.startIndex, startIndex + length)
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
    
    
}