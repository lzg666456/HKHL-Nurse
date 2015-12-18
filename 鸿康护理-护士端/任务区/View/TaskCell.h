//
//  TaskCell.h
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/19.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *creattime;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,assign)BOOL isPopular;
@end
