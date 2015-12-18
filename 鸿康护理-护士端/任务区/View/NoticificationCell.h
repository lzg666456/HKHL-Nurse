//
//  NoticificationCell.h
//  鸿康护理
//
//  Created by CaiNiao on 15/11/5.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticificationCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *infoDic;

@property (weak, nonatomic) IBOutlet UIImageView *unreadImg;
@end
