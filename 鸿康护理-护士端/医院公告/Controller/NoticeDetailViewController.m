//
//  NoticeDetailViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/19.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()<UIWebViewDelegate>

@end

@implementation NoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"公告详情";
    
    UIWebView *web = [[UIWebView alloc]init];
    [self.view addSubview:web];
    
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
    for (UIView *subView in web.subviews) {
        
        if ([subView isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)subView).showsVerticalScrollIndicator = NO;
        }
    }
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hk.zgcainiao.cn/index.php/admin/api/getNoticeInfo/id/%@",_ID]]]];
    web.delegate = self;
    [web scalesPageToFit];
}

#pragma mark - UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];
}



@end
