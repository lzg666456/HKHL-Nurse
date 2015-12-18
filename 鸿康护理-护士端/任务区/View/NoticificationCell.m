//
//  NoticificationCell.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/5.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "NoticificationCell.h"
#import "Utility.h"

@implementation NoticificationCell {
    
    __weak IBOutlet UILabel *typeLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *contentLabel;
    
    
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    _infoDic = infoDic;
    if ([_infoDic[@"type"] integerValue] == 1) {
        typeLabel.text = @"系统";
    }
    else {
        typeLabel.text = @"任务动态";
    }
    contentLabel.text = _infoDic[@"content"];
    
    timeLabel.text = [Utility timeintervalToDate:[_infoDic[@"createtime"] doubleValue] Formatter:@"MM月dd日 HH:mm"];
    
    if ([_infoDic[@"status"] integerValue] == 0) {
        
        _unreadImg.hidden = NO;
    }
    else {
        _unreadImg.hidden = YES;
    }
}

@end
