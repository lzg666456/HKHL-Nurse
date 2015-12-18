//
//  MyCollectCell.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/19.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//


#import "MyCollectCell.h"

@implementation MyCollectCell

- (void)setInfo:(NSDictionary *)info {
   
    _info = info;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _coverView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.5];
    _coverView.hidden = YES;
    
    if (_isCollect) {
        
        _statusLabel.hidden = YES;
    }
    
    NSData *data = [_info[@"sub_pic"] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_imgVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,arr[0]]] placeholderImage:[UIImage imageNamed:@"主图_xxhdpi"]];
    _titleLabel.text = _info[@"subject"];
    NSString *begin = [Utility timeintervalToDate:[_info[@"begintime"] doubleValue] Formatter:@"M月d日 hh:mm"];
    NSString *end = @" ";
    if (![_info[@"endtime"] isEqualToString:@"0"]) {
        end = [Utility timeintervalToDate:[_info[@"endtime"] doubleValue] Formatter:@"M月d日 hh:mm"];
    }
    else {
        end = @"无期限";
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@-%@",begin,end];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    
    
    //    ”verify_status”:”报名或指派状态： 0:未确认 }
    if ([_info[@"verify_status"] isEqualToString:@"0"]) {
        _statusLabel.textColor = [UIColor colorWithRed:119/256.0 green:119/256.0 blue:199/256.0 alpha:1];
        if (_type == Enroll) {
            
            _statusLabel.text = @"审核中";
        }
        if (_type == Attend) {
            
            _statusLabel.text = @"审核通过";
        }
        if (_type == assigned) {
            
            _statusLabel.hidden = YES;
            _hongImg.hidden = NO;
        }
    }
//    1:已确认 
    if ([_info[@"verify_status"] isEqualToString:@"1"]) {
        _hongImg.hidden = YES;
        _statusLabel.hidden = NO;
        _statusLabel.textColor = [UIColor colorWithRed:75/256.0 green:131/256.0 blue:231/256.0 alpha:1];
//        if (_type == Enroll) {
//            
//            _statusLabel.text = @"审核中";
//        }
        if (_type == Attend) {
            
            _statusLabel.text = @"审核通过";
        }
        if (_type == assigned) {
            
            _statusLabel.text = @"已接受";
            _statusLabel.backgroundColor = [UIColor redColor];
        }

        
    }
//    2:已否定”
    if ([_info[@"verify_status"] isEqualToString:@"2"]) {
        _hongImg.hidden = YES;
        _statusLabel.hidden = NO;
        _statusLabel.textColor = [UIColor colorWithRed:205/256.0 green:1/256.0 blue:1/256.0 alpha:1];
        if (_type == Enroll) {
            
            _statusLabel.text = @"审核未通过";
            _statusLabel.adjustsFontSizeToFitWidth = YES;
        }
//        if (_type == Attend) {
//            
//            _statusLabel.text = @"审核通过";
//        }
        if (_type == assigned) {
            
            _statusLabel.text = @"已拒绝";
        }

    }
    
    // 活动
    if (_isActivity) {
        
        if ([_info[@"verify_status"] isEqualToString:@"0"]) {
            _statusLabel.textColor = [UIColor colorWithRed:119/256.0 green:119/256.0 blue:199/256.0 alpha:1];
            _statusLabel.text = @"审核中";
        }
        //    1:已确认
        if ([_info[@"verify_status"] isEqualToString:@"1"]) {
            
            _statusLabel.textColor = [UIColor colorWithRed:75/256.0 green:131/256.0 blue:231/256.0 alpha:1];
            _statusLabel.text = @"审核通过";
        }
        //    2:已否定”
        if ([_info[@"verify_status"] isEqualToString:@"2"]) {
            
            _statusLabel.textColor = [UIColor colorWithRed:205/256.0 green:1/256.0 blue:1/256.0 alpha:1];
            _statusLabel.text = @"审核未通过";
            _statusLabel.adjustsFontSizeToFitWidth = YES;
        }
    }
    
    // 已关闭
    if ([_info[@"is_closed"] isEqualToString:@"1"]) {
        
        _coverView.hidden = NO;
        _statusLabel.text = @"已关闭";
        _statusLabel.textColor = [UIColor colorWithRed:119/256.0 green:119/256.0 blue:199/256.0 alpha:1];
    }
    else {
        
        // 已完成
        if ([_info[@"status"] isEqualToString:@"3"] || ([_info[@"endtime"] integerValue] > 0 &&  [[NSDate date] timeIntervalSince1970] > [_info[@"endtime"] doubleValue])) {
            
            _statusLabel.text = @"已完成";
            _statusLabel.textColor = [UIColor colorWithRed:119/256.0 green:119/256.0 blue:199/256.0 alpha:1];
        }
    }
    //状态在任务列表右下方表示：
    //审核中，审核未通过，已关闭（这三种是在“我报名的”里面），
    //审核通过，已完成，已关闭（这三种在“我参加的”里面），
    //已接受，已拒绝，已完成，已关闭（这四种在”被指派的“里面）
    //
    //审核未通过，已拒绝，用红字表示，色号#cd0101         205,1,1
    //审核通过，已接受，用蓝字表示，色号#4b83e7          75,131,231
    //审核中，已完成，已关闭，用黑字表示，色号#777777       119,119,119
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

@end
