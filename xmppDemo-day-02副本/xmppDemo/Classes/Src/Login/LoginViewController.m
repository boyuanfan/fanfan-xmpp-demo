//
//  LoginViewController.m
//  xmppDemo
//
//  Created by yztc on 16/10/24.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPManager.h"

@interface LoginViewController ()<XMPPStreamDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userNametf;
@property (strong, nonatomic) IBOutlet UITextField *passworttf;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //stream的两个代理者
    [ [XMPPManager ShareXMPPManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

//登录成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //NSUserDefaults
    //启动页？、引导页？
    //存储
    
    
    [[NSUserDefaults standardUserDefaults]setObject:self.userNametf.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:self.passworttf.text forKey:@"password"];
    //同步 -- 立即存储
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)xmppLoginAction:(UIButton *)sender {
    
    //其他的逻辑判断(用户名，密码不为空，etc)
    
    //传递数据
    XMPPManager *manager = [XMPPManager ShareXMPPManager];
    [manager xmppLoginWithUserName:self.userNametf.text password:self.passworttf.text];
}


@end
