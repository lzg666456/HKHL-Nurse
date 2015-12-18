//
//  ADDetailViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/30.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "ADDetailViewController.h"

@interface ADDetailViewController ()<UIWebViewDelegate>

@end

@implementation ADDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    UIWebView *webView = [[UIWebView alloc]init];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hk.zgcainiao.cn/index.php/admin/api/getAdvertisementInfo/id/%@",_ID]]]];
    
}

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
