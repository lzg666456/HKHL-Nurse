//
//  NoticeCell.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/19.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell


- (void)setInfo:(NSDictionary *)info {
    _info = info;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _contentLabel.text = _info[@"title"];
    _sourceLabel.text = _info[@"from"];
    _timeLabel.text = [Utility timeintervalToDate:[_info[@"createtime"] doubleValue] Formatter:@"MM-dd HH:mm"];
}
@end
