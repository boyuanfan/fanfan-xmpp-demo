//
//  ChatModelFrame.m
//  xmppDemo
//
//  Created by yztc on 16/10/27.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import "ChatModelFrame.h"
#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

//头像大小
#define HEAD_WIDTH 50
//间距
#define GAP 10
//文本最大宽度
#define TEXT_WIDTH (WIDTH - HEAD_WIDTH * 2 - GAP * 4)

@implementation ChatModelFrame

-(void)setMessage:(NSString *)message{
    _message = message;
    
    
    CGSize size = [message boundingRectWithSize:CGSizeMake(TEXT_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    //计算的过程（1.计算各个frames；2.记录cell总的高度）
    if (self.isFrom) {
        //from 左
        self.headImageFrame = CGRectMake(GAP, GAP, HEAD_WIDTH, HEAD_WIDTH);
        self.textFrame = CGRectMake(CGRectGetMaxX(self.headImageFrame) + GAP, GAP, TEXT_WIDTH, size.height);
        self.contentImageFrame = CGRectZero;
    }else{
        
        self.headImageFrame = CGRectMake(WIDTH - HEAD_WIDTH - GAP , GAP, HEAD_WIDTH, HEAD_WIDTH);
        self.textFrame = CGRectMake(HEAD_WIDTH + GAP * 2, GAP, TEXT_WIDTH, size.height);
        self.contentImageFrame = CGRectZero;

    }
    
    self.cellHeight = MAX(size.height, HEAD_WIDTH) + GAP * 2;
}

@end
