//
//  FindPwdViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/18.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "FindPwdViewController.h"
#import "ChangePwdViewController.h"
@interface FindPwdViewController ()
{
    UITextField *phoneTF;
    UITextField *codeTF;
    NSInteger second;
    NSString *Vcode;
}
@end

@implementation FindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"找回密码";
    self.navigationController.navigationBar.hidden = NO;
    [self createSubviews];
}

- (void)createSubviews {
    
    UIView *phoneView = [[UIView alloc]init];
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.layer.borderWidth = 2;
    phoneView.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(20);
        make.leading.equalTo(self.view).offset(self.view.width*0.1);
        make.height.equalTo(@40);
        make.width.mas_equalTo(self.view.width *0.6);
    }];
    
    phoneTF = [[UITextField alloc]init];
    phoneTF.placeholder = @"     请输入手机号";
    phoneTF.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    phoneTF.backgroundColor = [UIColor whiteColor];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(phoneView).offset(10);
        make.trailing.equalTo(phoneView).offset(-10);
        make.top.bottom.equalTo(phoneView);
    }];
    
    UIButton *getcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getcodeBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    getcodeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    getcodeBtn.titleLabel.numberOfLines = 0;
    getcodeBtn.backgroundColor = KNAVICOLOR;
    [getcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getcodeBtn.layer.cornerRadius = 4;
    [getcodeBtn addTarget:self action:@selector(getcodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getcodeBtn];
    [getcodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(phoneView.mas_trailing).offset(5);
        make.height.top.equalTo(phoneView);
        make.width.mas_equalTo(self.view.width*0.2);
    }];
    
    
    UIView *codeView = [[UIView alloc]init];
    codeView.backgroundColor = [UIColor whiteColor];
    codeView.layer.borderWidth = 2;
    codeView.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
    [self.view addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(phoneView.mas_bottom).offset(15);
        make.leading.equalTo(phoneView);
        make.height.equalTo(@40);
        make.width.mas_equalTo(self.view.width *0.8+5);
    }];

    
    codeTF = [[UITextField alloc]init];
    codeTF.placeholder = @"    请输入验证码";
    codeTF.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:codeTF];
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(codeView).offset(10);
        make.trailing.equalTo(codeView).offset(-10);
        make.top.bottom.equalTo(codeView);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 4;
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    nextBtn.backgroundColor = KNAVICOLOR;
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.with.trailing.equalTo(codeView);
        make.top.equalTo(codeView.mas_bottom).offset(50);
        make.height.equalTo(@40);
    }];
}



// 获取验证码
- (void)getcodeAction:(UIButton *)button {
    
    if (!phoneTF.text.length) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (![Utility isValidateMobile:phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"号码无效，请重新输入"];
        return;
    }
    [DataService requestURL:@"getVcode" httpMethod:@"post" timeout:10 params:@{@"phone":phoneTF.text} responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                Vcode = [result[@"vcode"] stringValue];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:button repeats:YES];
                second = 59;
                button.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1];
                [button setTitle:[NSString stringWithFormat:@"%lds重试",(long)second] forState:UIControlStateNormal];
                button.enabled = NO;
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

- (void)timeAction:(NSTimer *)timer {
    
    UIButton *button = timer.userInfo;
    second--;
    [button setTitle:[NSString stringWithFormat:@"%lds重试",(long)second] forState:UIControlStateNormal];
    if (second == 0) {
        
        [button setTitle:@"点击获取验证码" forState:UIControlStateNormal];
        button.backgroundColor = KNAVICOLOR;
        button.enabled = YES;
        [timer invalidate];
        timer = nil;
    }
}

#warning !~~~
// 下一步
- (void)nextAction {
    
    if (!phoneTF.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (![codeTF.text isEqualToString:Vcode]) {
        
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return;
    }

    ChangePwdViewController *changeVC = [[ChangePwdViewController alloc]init];
    changeVC.isFind = YES;
    changeVC.phone = phoneTF.text;
    [self.navigationController pushViewController:changeVC animated:YES];
}
@end
