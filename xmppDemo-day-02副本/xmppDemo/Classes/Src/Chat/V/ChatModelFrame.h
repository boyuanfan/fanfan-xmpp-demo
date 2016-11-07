//
//  ChatModelFrame.h
//  xmppDemo
//
//  Created by yztc on 16/10/27.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModelFrame : NSObject

@property(nonatomic,assign) CGRect headImageFrame;
@property(nonatomic,assign) CGRect textFrame;
@property(nonatomic,assign) CGRect contentImageFrame;

//cell所对应的数据
@property(nonatomic,strong) NSString * message;
//cell总高度
@property(nonatomic,assign) CGFloat  cellHeight;

//左右
@property(nonatomic,assign) BOOL isFrom;

@end
