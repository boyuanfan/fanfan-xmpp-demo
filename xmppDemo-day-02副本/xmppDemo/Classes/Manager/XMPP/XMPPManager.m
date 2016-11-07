//
//  XMPPManager.m
//  xmppDemo
//
//  Created by yztc on 16/10/25.
//  Copyright © 2016年 yztc. All rights reserved.
//

//数据持久化：plist，NSUserDefaults，数据归档（NSKeyedArchieve），NSFileManager，sqlite，coredata
//系统单例类：NSUserDefaults，NSFileManager，NSNotificationCenter，NSURLCache


/*
 1. 单例模式应用场景
 2. 系统有哪些，如何实现
 3. 自己如何实现，必须能手写
 4. 实现全局唯一实体，重写allocWithZone（alloc init，，new）
 5. 通过宏定义，提取自己的工具类
 
 登录：
 1.创建通讯管道 -- 指定jid
 2.链接服务器 -- 认证
 3.更改登录状态 构造XMPPPresence消息
 4.重连disconnect
 
 
 
注册：
 
 */
#import "XMPPManager.h"
typedef enum :NSInteger{
    LoginType = 1, //1.登录
    RegisterType  //2.注册
    //...
}ActionType;

static XMPPManager *xmppM = nil;
@interface XMPPManager()<XMPPStreamDelegate,XMPPRosterDelegate,XMPPReconnectDelegate>

//记录登录密码
@property(nonatomic,strong) NSString * passwordStr;
//记录注册密码
@property(nonatomic,strong) NSString * registerPasswordStr;
//记录事件 - 登录？注册
@property(nonatomic,assign) ActionType type;



@end
@implementation XMPPManager

#pragma mark -- 单例创建
+(instancetype)ShareXMPPManager{
    
//    @synchronized(self) {
//        if (xmppM == nil) {
//            xmppM = [[XMPPManager alloc]init];
//        }
//    }
//    return xmppM;
//}

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         xmppM = [[XMPPManager alloc]init];
    });
    return xmppM;
}

//加上这个方法无论单例，alloc init，，new三种方法创建的都将是同一个对象，分配的同一个地址
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        xmppM = [super allocWithZone:zone];

    });
    return xmppM;
}

#pragma mark -- 初始化工作
-(instancetype)init{
    if (self = [super init]) {
        //1. 通讯管道创建，设置
        _stream = [[XMPPStream alloc]init];
        //设置服务器地址
        _stream.hostName = kHostName;
        //设置服务器端口号
        _stream.hostPort = kHostPort;
        //代理回调
        [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //2. 花名册
        // 存储花名册的作用，通过coredata方式存储
        XMPPRosterCoreDataStorage *rcds = [XMPPRosterCoreDataStorage sharedInstance];
        //构造花名册（全局队列：避免阻塞主线程），回顾：GCD
        self.roster = [[XMPPRoster alloc]initWithRosterStorage:rcds dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        //激活花名册 （监测：好友申请等）
        [self.roster activate:_stream];
        //代理回调
        [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        //3. 自动重连
        self.reconnect = [[XMPPReconnect alloc]init];
        //设置自动重连
        self.reconnect.autoReconnect = YES;//默认为YES
        //重连时间(单位：s)
        self.reconnect.reconnectTimerInterval = 10;
        //激活自动重连
        [self.reconnect activate:_stream];
        //回调
        [self.reconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    return self;
}

#pragma mark -- XMPPStreamDelegate链接服务器
-(void)xmppStreamWillConnect:(XMPPStream *)sender{
   
    NSLog(@"即将链接服务器");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    NSLog(@"链接服务器成功");

    
    switch (self.type) {
        case LoginType:
        {
            //账户和密码认证，如果认证通过，则标示登录成功,发起登录认证事件
            [_stream authenticateWithPassword:self.passwordStr error:nil];
            break;
        }
        case RegisterType:
        {
            //发起注册事件
            [_stream registerWithPassword:self.registerPasswordStr error:nil];
            break;
        }
   
        default:
            break;
    }
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    
    NSLog(@"链接服务器超时");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"链接服务器失败：%@",error);
}

#pragma mark -- 登录功能的实现(账户登录)
-(void)xmppLoginWithUserName:(NSString *)userName password:(NSString *)password{
    //记录密码
    self.passwordStr = password;
    //构造XMPPJID(唯一的标示)
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:kDomin resource:kResource];
    //设置账户jid
    _stream.myJID = jid;
    //记录状态
    self.type = LoginType;
    
    [self xmppConnectToServer];
    
}

#pragma mark -- 登录认证事件
//认证失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    
    NSLog(@"认证失败");

}

//认证成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    NSLog(@"认证成功");
    //构造出席消息
    XMPPPresence *onLine = [XMPPPresence presenceWithType:@"online"];
    //发送到服务器
    [_stream sendElement:onLine];
    
    
}


#pragma mark -- 注册功能实现
-(void)xmppRegisterWithUserName:(NSString *)userName password:(NSString *)password{
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:kDomin resource:kResource];
    _stream.myJID = jid;
    self.registerPasswordStr = password;
    //记录状态
    self.type = RegisterType;
    //链接服务器
    [self xmppConnectToServer];
    
}
#pragma mark -- 注册事件代理
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败:%@",error);
}

-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
}
#pragma mark --判断和链接服务器
-(void)xmppConnectToServer{
    //修改重连问题
    if ([_stream isConnected] || [_stream isConnecting]) {
        //断开链接
        [_stream disconnect];
    }
    
    //链接服务器
    NSError *error = nil;
    BOOL result = [_stream connectWithTimeout:30 error:&error];
    if (!result) {
        
        NSLog(@"链接失败：%@",error);
    }

}

#pragma mark -- XMPPRosterDelegate花名册相关
//收到出席订阅请求回调的方法
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    

    
}
//该方法会被多次调用，用来逐个接收好友
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item{
    
}
//开始接收
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender{
    
}
//结束接收
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    
}

#pragma mark --XMPPReconnectDelegate--自动重连
- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags{
    NSLog(@"监测到网络断开。。。");
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags{
    NSLog(@"自动重连。。。");
    return YES;
}
@end
