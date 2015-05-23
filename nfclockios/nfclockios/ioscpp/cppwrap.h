//
//  cppwrap.h
//  cpphonemodule
//
//  Created by wxqdev on 14-11-18.
//
//

#ifndef cppwrap_h
#define cppwrap_h

#include <string>

#include <boost/function.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/bind.hpp>

typedef boost::function<void(boost::shared_ptr<std::string> pMsgReply)> ReqMsgCallBack;
std::string _initModule(const std::string&scmdline, ReqMsgCallBack callback);
std::string _sendMessage(const std::string&sMsg);
std::string _sendMessage(const std::string&sMsg, ReqMsgCallBack callback);
void _stopModule();

#endif