//
//  ChatCell.h
//  xmppDemo
//
//  Created by yztc on 16/10/27.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModelFrame.h"

@interface ChatCell : UITableViewCell
//注意：命名不要用imageView、textLabel。。避免混淆
@property(nonatomic,strong) UIImageView *headImageView;//头像
@property(nonatomic,strong) UILabel * contentLabel;//文本
@property(nonatomic,strong) UIImageView * contentImageView;//图片


@property(nonatomic,strong) ChatModelFrame * chatFrame;


@end
