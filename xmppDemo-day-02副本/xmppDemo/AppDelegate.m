//
//  AppDelegate.m
//  xmppDemo
//
//  Created by yztc on 16/10/24.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "XMPPManager.h"
//#import "Login.storyboard"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];

    //取值 key-value
   NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
   NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];

    if (name && password) {
        //登陆过，自动登录
        [[XMPPManager ShareXMPPManager]xmppLoginWithUserName:name password:password];
    }else{
    //从工程中找到Login Storyboard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //取到Login.storyboard中的厨师控制器：导航控制器
    UIViewController *vc = [sb instantiateInitialViewController];
    //模态展示登录页面
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    //self.window.rootViewController = vc;
    }
    
    return YES;
}


@end
