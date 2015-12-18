//
//  CertificatesViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/23.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "CertificatesViewController.h"
#import "AddCertificateViewController.h"
@interface CertificatesViewController ()<UIAlertViewDelegate,AddCertificateDelegate>
{
    UIScrollView *_scroll;
    UIButton *addBtn;
    CGFloat maxY;
    NSArray *bgColors;
    NSMutableArray *certificates;
}
@end

@implementation CertificatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"职业认证";
    certificates = [NSMutableArray array];
    bgColors = @[[UIColor colorWithRed:0.075f green:0.698f blue:0.769f alpha:1.00f],[UIColor colorWithRed:0.000f green:0.494f blue:0.996f alpha:1.00f],[UIColor colorWithRed:0.584f green:0.929f blue:0.953f alpha:1.00f],[UIColor colorWithRed:0.192f green:0.506f blue:0.745f alpha:1.00f],[UIColor colorWithRed:0.133f green:0.447f blue:0.525f alpha:1.00f],[UIColor colorWithRed:0.392f green:0.808f blue:0.404f alpha:1.00f]];
    [self createSubviews];
    
    [self loadData];
}

// 获取证书
- (void)loadData {
    
    [DataService requestURL:@"getNurseCredentials" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID]} responseSerializer:nil completion:^(id result, NSError *error) {
       
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                certificates = [result[@"list"] mutableCopy];
                [self createCertificateViews];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

// 创建子视图
- (void)createSubviews {
    
    _scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scroll.height = self.view.height - 50;
    _scroll.backgroundColor = [UIColor whiteColor];
    _scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    maxY = 20;
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(20, maxY+10, _scroll.width-40, 30);
    [addBtn setTitle:@"添加证件" forState:UIControlStateNormal];
    addBtn.layer.borderColor = KNAVICOLOR.CGColor;
    addBtn.layer.borderWidth = 1.5;
    addBtn.layer.cornerRadius = 5;
    [addBtn setTitleColor:KNAVICOLOR forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addCertificate) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:addBtn];
    
    
}

// 创建证书视图列表
- (void)createCertificateViews {
    
    for (int i = 0; i< certificates.count; i++) {
        
        [self createCertificateViewWithIndex:i];
    }
    if (certificates.count >= 3) {
        
        addBtn.hidden = YES;
    }
    addBtn.y = maxY + 10;
    _scroll.contentSize = CGSizeMake(_scroll.width, addBtn.bottom+20);
}

// 创建单个证书视图
- (void)createCertificateViewWithIndex:(NSInteger)index {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(20, maxY, _scroll.width-40, 120)];
    bgView.layer.cornerRadius = 4;
    bgView.backgroundColor = bgColors[arc4random()%bgColors.count];
    [_scroll addSubview:bgView];
    bgView.tag = index+100;
    maxY += 140;
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(delAction:)];
    longpress.minimumPressDuration = 0.3;
    [bgView addGestureRecognizer:longpress];
    
    // 证书名
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, bgView.width-25, 20)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:FONT_SIZE_LARGE];
    title.text = certificates[index][@"name"];
    title.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:title];
    
    CGRect rect = [title.text boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_LARGE]} context:nil];
    UILabel *waitReview = [[UILabel alloc]initWithFrame:CGRectMake(rect.size.width+30, 20, 50, 20)];
    waitReview.font = [UIFont systemFontOfSize:FONT_SIZE_SMALL];
    waitReview.textColor = [UIColor whiteColor];
    waitReview.textAlignment = NSTextAlignmentCenter;
    waitReview.text = @"待验证";
    waitReview.backgroundColor = [UIColor colorWithRed:0.161f green:0.365f blue:0.624f alpha:1.00f];
    [bgView addSubview:waitReview];
    waitReview.hidden = YES;
    
    // 证书号
    UILabel *cardNo = [[UILabel alloc]initWithFrame:CGRectMake(20, title.bottom+20, bgView.width-25, 40)];
    cardNo.font = [UIFont systemFontOfSize:FONT_SIZE_LARGE+15];
    cardNo.text = certificates[index][@"credentials_code"];
    cardNo.textColor = [UIColor whiteColor];
    cardNo.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:cardNo];
    
}

// 添加证书
- (void)addCertificate {
    
    self.hidesBottomBarWhenPushed = YES;
    AddCertificateViewController *addVC = [[AddCertificateViewController alloc]init];
    addVC.delegate = self;
    [self.navigationController pushViewController:addVC animated:YES];
}

// 长按删除手势
- (void)delAction:(UILongPressGestureRecognizer *)longpress {
 
    if (longpress.state == UIGestureRecognizerStateEnded) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = longpress.view.tag;
        [alert show];
    }
    
}
#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
            // 取消
        case 0:
            
            break;
            
            // 确定
        default:
            if (certificates.count <= 1) {
                
                [SVProgressHUD showErrorWithStatus:@"最少保留一张证件"];
                return;
            }
            [DataService requestURL:@"delNurseCredentials" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"id":certificates[alertView.tag -100][@"id"]} responseSerializer:nil completion:^(id result, NSError *error) {
                
                if (error == nil) {
                    
                    if ([result[@"err"] isEqualToNumber:@0]) {
                        
                        [certificates removeObjectAtIndex:alertView.tag -100];
                        [self removeSubviews];
                        maxY = 20;
                        
                        addBtn.hidden = NO;
                        [self createCertificateViews];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:error.domain];
                }
            }];
            break;
    }
}

// 移除所有视图
- (void)removeSubviews {
    
    for (UIView *subView in [_scroll subviews]) {
        if (subView != addBtn) {
            
            [subView removeFromSuperview];
        }
    }
}

#pragma mark - AddCertificateDelegate
- (void)AddCertificateSuccess:(NSDictionary *)certificate {
    
    [certificates addObject:certificate];
    [self removeSubviews];
    maxY = 20;
    [self createCertificateViews];
}
@end
