//
//  SelectCell.m
//  鸿康护理（护士端）
//
//  Created by CaiNiao on 15/11/18.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "SelectCell.h"

@implementation SelectCell {
    UILabel *label;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _createView];
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self _createView];
    }
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self _createView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _createView];
    }
    return self;
}

- (void)_createView {
    label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.textColor =  [UIColor blackColor];
    [self.contentView addSubview:label];
}

- (void)setTextstring:(NSString *)textstring {
    _textstring = textstring;
    label.text = textstring;
}

- (void)layoutSubviews {
    label.frame = CGRectMake(0, 0, self.width, self.height);
}
@end
