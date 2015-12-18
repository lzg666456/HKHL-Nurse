//
//  ProgressImgView.h
//  福报健康
//
//  Created by 肖胜 on 15/9/25.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressImgView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame UrlString:(NSString *)urlsting placeImgName:(UIImage *)placeImg;

- (void)setimageWithUrlString:(NSString *)stringUrl placeImg:(UIImage *)placeImg;
@end
