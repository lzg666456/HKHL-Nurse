//
//  ActivityCell.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/19.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

- (void)setIsPopular:(BOOL)isPopular {
    
    _isPopular = isPopular;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    
//    begintime = 1448758800;
//    createtime = 1448011624;
//    endtime = 1448791200;
//    id = 4;
//    number = "<null>";
//    "sub_pic" = "[\"\\/Uploads\\/Images\\/2015-11-20\\/564ee76a0eac7.png\"]";
//    subject = "\U5fd7\U613f\U4e0b\U4e61\U4e49\U8bca
    [super layoutSubviews];
    _isNewLabel.layer.cornerRadius = _isNewLabel.width/2.0;
    _isNewLabel.clipsToBounds = YES;
    if (_isPopular) {
        
        if ([_info[@"number"] isKindOfClass:[NSNull class]]) {
            
            _timeLabel.text = @"0人报名";
        }
        else {
            _timeLabel.text = [NSString stringWithFormat:@"%@人报名",_info[@"number"]];
        }
    }
    else {
        _timeLabel.text = [Utility timeintervalToDate:[_info[@"createtime"] doubleValue] Formatter:@"MM月dd日 HH:mm"];
        
    }
    _contentLabel.text = _info[@"subject"];
   

}
@end
