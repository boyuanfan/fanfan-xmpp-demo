//
//  RigisterViewController.m
//  xmppDemo
//
//  Created by yztc on 16/10/24.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import "RigisterViewController.h"
#import "XMPPManager.h"

@interface RigisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userNametf;

@property (strong, nonatomic) IBOutlet UITextField *passwordtf;
@end

@implementation RigisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)registerAction:(UIButton *)sender {
    
    XMPPManager *manager = [XMPPManager ShareXMPPManager];
    [manager xmppRegisterWithUserName:self.userNametf.text password:self.passwordtf.text];
}

@end
