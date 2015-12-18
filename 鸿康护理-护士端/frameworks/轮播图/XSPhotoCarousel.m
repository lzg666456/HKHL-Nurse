//
//  XSPhotoCarousel.m
//  MasonryExe
//
//  Created by 肖胜 on 15/11/14.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//


#import "XSPhotoCarousel.h"

NSTimer *_timer;
NSArray *_images;
ImageType _imageType;
UIPageControl *page;
UIScrollView *_scrollView;
BOOL _autoScroll;
UIImage *_placeImg;
@implementation XSPhotoCarousel


- (instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images ImageType:(ImageType)imageType AutoScroll:(BOOL)autoScroll placeImg:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _images = images;
        _imageType = imageType;
        _autoScroll = autoScroll;
        _placeImg = image;
        [self loadViews];
    }
    return self;
}


- (void)loadViews {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*_images.count, _scrollView.frame.size.height);
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < _images.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imgView.image = _placeImg;
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imgView addGestureRecognizer:tap];
        imgView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        if (_imageType == ImageTypeImage) {
            
            imgView.image = _images[i];
        }
        if (_imageType == ImageTypeLocalPath) {
            
            imgView.image = [UIImage imageNamed:_images[i]];
        }
        if (_imageType == ImageTypeUrlString) {
        
            [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,_images[i]]] placeholderImage:_placeImg];
        }
        [_scrollView addSubview:imgView];
    }
    
    // 小圆点
    page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame)-30, _scrollView.frame.size.width, 20)];
    page.numberOfPages = _images.count;
    page.currentPageIndicatorTintColor = [UIColor redColor];
    page.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:page];
    
    // 是否自动轮播
    if (_autoScroll) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(autoScrollView) userInfo:nil repeats:YES];
    }
}



// 自动滚动
- (void)autoScrollView {
    
    if (_scrollView == nil) {
        return;
    }

    if (_scrollView.contentOffset.x == _scrollView.width*(_images.count-1)) {
        
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+_scrollView.width, 0) animated:YES];
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    page.currentPage = _scrollView.contentOffset.x/_scrollView.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    page.currentPage = _scrollView.contentOffset.x/_scrollView.frame.size.width;
}


// 图片点击
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(clickImgAtIndex:)]) {
        
        [_delegate clickImgAtIndex:tap.view.tag];
    }
}



- (void)removeFromSuperview {
    
    if (_timer != nil) {
    
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc {
    
    [_timer invalidate];
    _timer = nil;
}
@end
