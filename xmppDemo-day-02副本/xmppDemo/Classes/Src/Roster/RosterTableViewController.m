//
//  RosterTableViewController.m
//  xmppDemo
//
//  Created by yztc on 16/10/26.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import "RosterTableViewController.h"
#import "XMPPManager.h"
#import "ChatViewController.h"
@interface RosterTableViewController ()<XMPPRosterDelegate>
//数据源
@property(nonatomic,strong) NSMutableArray * rosterArray;

@property(nonatomic,strong) XMPPJID * jid;


@end

@implementation RosterTableViewController
-(NSMutableArray *)rosterArray{
    if (_rosterArray == nil) {
        _rosterArray = [NSMutableArray array];
    }
    return _rosterArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //目的：监测收到好友请求的处理（提供选项：同意or拒绝）
    [[XMPPManager ShareXMPPManager].roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rosterArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell复用
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    XMPPJID *jid = self.rosterArray[ self.rosterArray.count - indexPath.row - 1];
    cell.textLabel.text = [jid bare];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //segue 关联
    if ([segue.identifier isEqualToString:@"ChatViewController"]) {
        //1.得到要传递的数据
        //锁定点击是哪个cell  --- sender
        UITableViewCell *theCell = (UITableViewCell *)sender;
        //确定cell在列表中的索引
        NSIndexPath *indexPath = [self.tableView  indexPathForCell:theCell];
        //根据索引从rosterArray中找到对应的数据
        self.jid = self.rosterArray[self.rosterArray.count - 1 - indexPath.row];
        //2.取到ChatVC的实例（注意：不要alloc init）
        ChatViewController *chatVC = (ChatViewController *)segue.destinationViewController;
        chatVC.toChatJID = self.jid;
    }
}

#pragma mark -- XMPPRosterDelegate花名册处理
//Example:
//*
//* <item jid='romeo@example.net' name='Romeo' subscription='both'>
//*   <group>Friends</group>
//* </item>

//该方法会被多次调用，用来逐个接收好友
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item{
    static NSInteger index = 0;
    NSLog(@"%ld ,%@",index ++,item);
    
    //解析item
    NSString *subscription = [[item attributeForName:@"subscription"] stringValue];
    //如果关系为both，才添加至列表中
    if (![subscription isEqualToString:@"both"]) {
        return;
    }
    //满足，添加数据源
    NSString *jidStr = [[item attributeForName:@"jid"] stringValue];
    //?
    XMPPJID *jid = [XMPPJID jidWithString:jidStr resource:kResource];
    [self.rosterArray addObject:jid];
    //刷新表
    //[self.tableView reloadData];
//    [self.tableView reloadRowsAtIndexPaths:<#(nonnull NSArray<NSIndexPath *> *)#> withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadSections:<#(nonnull NSIndexSet *)#> withRowAnimation:<#(UITableViewRowAnimation)#>]
    //置顶插入新数据(----------------tableview如何刷新，，，刷新的顺序)
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    //字面量
    //@""  @[]   @{}  @10  @12.7  @YES
    //NSNumber
}

//收到出席订阅请求回调的方法
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
//    UIAlertControllerStyleActionSheet = 0,
//    UIAlertControllerStyleAlert

    //好友关系
    //presence：both，from，to，remove，none
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"好友申请" message:[NSString stringWithFormat:@"%@申请成为你的好友",presence.from.user] preferredStyle:UIAlertControllerStyleActionSheet];
    //同意
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[XMPPManager ShareXMPPManager].roster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
        //[self.tableView reloadData];
    }];
    //拒绝
    UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [[XMPPManager ShareXMPPManager].roster rejectPresenceSubscriptionRequestFrom:presence.from];
    }];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
       // [XMPPManager ShareXMPPManager].roster
    }];
    //添加动作
    [alertVC addAction:agreeAction];
    [alertVC addAction:rejectAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark--退回登录界面
- (IBAction)backAction:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *vc = storyboard.instantiateInitialViewController;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
