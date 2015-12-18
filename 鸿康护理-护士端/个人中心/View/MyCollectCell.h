//
//  MyCollectCell.h
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/19.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    Enroll,
    Attend,
    assigned,
} Type;

@interface MyCollectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgVIew;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *hongImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic,assign)BOOL isCollect;
@property (nonatomic,assign)BOOL isActivity;
@property (nonatomic,strong)NSDictionary *info;
@property (nonatomic,assign)Type type;
@end
