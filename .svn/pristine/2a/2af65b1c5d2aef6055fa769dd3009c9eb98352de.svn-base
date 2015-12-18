//
//  StarView.m
//  WXMovie
//
//  Created by wei.chen on 15/2/6.
//  Copyright (c) 2015年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "StarView.h"

@implementation StarView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self _createView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self _createView];
    }
    
    return self;
}

//创建子视图
- (void)_createView {
    
    UIImage *yelloImg = [UIImage imageNamed:@"yellow"];
    UIImage *grayImg = [UIImage imageNamed:@"gray"];
    
    //1.创建灰色星星
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, grayImg.size.width*5, grayImg.size.height)];
    _grayView.backgroundColor = [UIColor colorWithPatternImage:grayImg];
    [self addSubview:_grayView];
    
    //2.创建金色星星视图
    _yelloView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, yelloImg.size.width*5, yelloImg.size.height)];
    _yelloView.backgroundColor = [UIColor colorWithPatternImage:yelloImg];
    [self addSubview:_yelloView];
    
    //3.设置当前视图的尺寸
    CGRect frame = self.frame;
    frame.size.width = self.frame.size.height*5;
    self.frame = frame;
    
    //4.计算缩放的倍数
    CGFloat scale = self.frame.size.height/yelloImg.size.height;
    _grayView.transform = CGAffineTransformMakeScale(scale, scale);
    _yelloView.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGRect frame1 = _grayView.frame;
    frame1.origin = CGPointZero;
    _grayView.frame = frame1;
    
    CGRect frame2 = _yelloView.frame;
    frame2.origin = CGPointZero;
    _yelloView.frame = frame2;
    
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setRating:(CGFloat)rating {
    _rating = rating;
    
    CGFloat s = _rating/10.0;
    
    CGFloat width = _yelloView.frame.size.width * s;
    CGRect frame =  _yelloView.frame;
    frame.size.width = width;
    _yelloView.frame = frame;
    
}

@end
