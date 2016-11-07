//
//  ChatCell.m
//  xmppDemo
//
//  Created by yztc on 16/10/27.
//  Copyright © 2016年 yztc. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//纯代码-cell布局
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        _headImageView = [[UIImageView alloc]init];
        _headImageView.image = [UIImage imageNamed:@"ha.jpg"];
        [self.contentView addSubview:_headImageView];
        
        //
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        //
        _contentImageView = [[UIImageView alloc]init];
       // _contentImageView.image = [UIImage imageNamed:@"ha.jpg"];
        [self.contentView addSubview:_contentImageView];
    }
    return self;
}

//-(void)setMessage:(NSString *)message{
//    _message = message;
//    
//    if (arc4random() %2 ) {
//        // 1 from
//        _contentLabel.textAlignment = NSTextAlignmentLeft;
//    }else{
//        _contentLabel.textAlignment = NSTextAlignmentRight;
//    }
//    //
//    _contentLabel.text = message;
//    
//    //frames
//    
//}

-(void)setChatFrame:(ChatModelFrame *)chatFrame{
    _chatFrame = chatFrame;
    
    //1.设置数据
    if (chatFrame.isFrom) {
                // 1 from
                _contentLabel.textAlignment = NSTextAlignmentLeft;
            }else{
                _contentLabel.textAlignment = NSTextAlignmentRight;
            }
            //
            _contentLabel.text = chatFrame.message;
            

    //2.修改Frames
    _headImageView.frame = chatFrame.headImageFrame;
    _contentLabel.frame = chatFrame.textFrame;
    _contentImageView.frame = chatFrame.contentImageFrame;
    
    
}

@end
