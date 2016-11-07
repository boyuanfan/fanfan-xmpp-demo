//
//  ChatViewController.m
//  xmppDemo
//
//  Created by yztc on 16/10/26.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import "ChatModelFrame.h"

#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableView
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//最下方 输入条
@property (strong, nonatomic) IBOutlet UIView *inputBarView;
//输入文本框
@property (strong, nonatomic) IBOutlet UITextField *inputTf;
//数据源
@property(nonatomic,strong) NSMutableArray * chatArray;

@end

@implementation ChatViewController

-(NSMutableArray *)chatArray{
    if (_chatArray == nil) {
        _chatArray = [NSMutableArray array];
        NSArray *arr = @[@"fanfan",@"like",@"exo",@"fefijifjieorfjoerififrifjroijfirofjrifjifjrifjrfjrifjrifrijfir",@"do you know"];
        for (NSString *str in arr) {
            ChatModelFrame *modelFrame = [[ChatModelFrame alloc]init];
            modelFrame.isFrom = arc4random() % 2 == 0 ? NO : YES;
            modelFrame.message = str;

            NSLog(@"----%d",modelFrame.isFrom);
            [self.chatArray addObject:modelFrame];
        }
        

        
    }
    return _chatArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"和<%@>聊天中",self.toChatJID.user];
    //创建单击手势 -> 收回键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboardAction:)];
   // self.tableView.userInteractionEnabled = YES;
    [self.tableView addGestureRecognizer:tap];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //cell提前注册
    [self.tableView registerClass:[ChatCell class] forCellReuseIdentifier:@"ChatCell"];
    
    
    //构造假数据
//    [self.chatArray addObjectsFromArray:@[@"fanfan",@"like",@"exo",@"fefijifjieorfjoerififrifjroijfirofjrifjifjrifjrfjrifjrifrijfir",@"do you know"]];

    
}
#pragma mark -- tableView手势响应方法
-(void)hideKeyboardAction:(UITapGestureRecognizer *)tap{
    
    //取消响应方法一(取消特定的一个)
    //[self.inputTf resignFirstResponder];
    //取消响应方法二（取消所有）
    [self.view endEditing:YES];
    
}
#pragma mark -- 监听键盘frame改变执行的方法
//获取键盘高度的变化，进而控制视图的偏移
-(void)keyboardFrameChange:(NSNotification *)notification{
    
    NSLog(@"%@",notification.userInfo);
    
    //begin
    CGRect beginFrame = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //end
    CGRect endFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //duration
    CGFloat timeDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    //得到键盘偏移量
    CGFloat offsetY = endFrame.origin.y - beginFrame.origin.y;
    //动画
    [UIView animateWithDuration:timeDuration animations:^{
        
      //  self.view.center.y =
        CGRect rect = self.view.frame;
        rect.origin.y += offsetY;
        self.view.frame = rect;

    }];
    
}
#pragma mark -- 发送消息方法
//发送图片
- (IBAction)chatChoosePhotoAction:(id)sender {

}
//发送文本
- (IBAction)sendTextAction:(id)sender {
}

#pragma mark -- tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //cell复用
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    
    //传递数据
    cell.chatFrame = self.chatArray[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModelFrame *model = self.chatArray[indexPath.row];
    return model.cellHeight;
}


@end
