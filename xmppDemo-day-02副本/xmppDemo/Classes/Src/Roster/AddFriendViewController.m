//
//  AddFriendViewController.m
//  xmppDemo
//
//  Created by yztc on 16/10/26.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import "AddFriendViewController.h"
#import "XMPPManager.h"
@interface AddFriendViewController ()

@property (strong, nonatomic) IBOutlet UITextField *jidTf;
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)addFriendAction:(id)sender {

    XMPPJID *jid = [XMPPJID jidWithUser:self.jidTf.text domain:kDomin resource:kResource];
    //向别人发起订阅请求
    [[XMPPManager ShareXMPPManager].roster subscribePresenceToUser:jid];
}

@end
