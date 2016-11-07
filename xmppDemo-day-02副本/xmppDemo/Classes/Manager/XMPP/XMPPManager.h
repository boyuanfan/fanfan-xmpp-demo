//
//  XMPPManager.h
//  xmppDemo
//
//  Created by yztc on 16/10/25.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPPManager : NSObject

//通讯管道
@property(nonatomic,strong) XMPPStream * stream;

//花名册
@property(nonatomic,strong) XMPPRoster * roster;

//自动重连
@property(nonatomic,strong) XMPPReconnect * reconnect;


+(instancetype)ShareXMPPManager;


//登录功能
-(void)xmppLoginWithUserName:(NSString *)userName
                    password:(NSString *)password;

//注册功能
-(void)xmppRegisterWithUserName:(NSString *)userName
                       password:(NSString *)password;
@end
