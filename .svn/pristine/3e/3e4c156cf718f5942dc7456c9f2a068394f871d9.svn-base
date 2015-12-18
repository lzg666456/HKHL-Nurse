//
//  ProgressImgView.m
//  福报健康
//
//  Created by 肖胜 on 15/9/25.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "ProgressImgView.h"

@implementation ProgressImgView

- (instancetype)initWithFrame:(CGRect)frame UrlString:(NSString *)urlsting placeImgName:(UIImage *)placeImg {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        __block UIProgressView *progress;
        [self sd_setImageWithURL:[NSURL URLWithString:urlsting] placeholderImage:placeImg options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
           
            if (progress == nil) {
                
                progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
                progress.frame = CGRectMake(0, self.height*0.5-2, self.width, 4);
                [self addSubview:progress];
            }
            progress.progress = (float)receivedSize/(float)expectedSize;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [progress removeFromSuperview];
        }];
    }
    return self;
}

- (void)setimageWithUrlString:(NSString *)stringUrl placeImg:(UIImage *)placeImg{
    
    __block UIProgressView *progress;
    [self sd_setImageWithURL:[NSURL URLWithString:stringUrl] placeholderImage:placeImg options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        if (progress == nil) {
            
            progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
            progress.frame = CGRectMake(0, self.height*0.5-2, self.width, 4);
            [self addSubview:progress];
        }
        progress.progress = (float)receivedSize/(float)expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [progress removeFromSuperview];
    }];

}

@end
