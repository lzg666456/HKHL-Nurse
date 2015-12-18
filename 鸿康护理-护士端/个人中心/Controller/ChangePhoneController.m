//
//  ChangePhoneController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/12/2.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "ChangePhoneController.h"
#import "LoginViewController.h"
@interface ChangePhoneController ()<UITextFieldDelegate>
{
    UITextField *pwdTF;
    UITextField *phoneTF;
    UITextField *codeTF;
    UIButton *codeBtn;
    NSInteger second;
    NSString *code;
    UIButton *subminBtn;
}
@end

@implementation ChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改手机号";
    
    [self loadViews];
}

- (void)loadViews {
    
    // 密码
    pwdTF = [[UITextField alloc]init];
    [self.view addSubview:pwdTF];
    pwdTF.secureTextEntry = YES;
    pwdTF.borderStyle = UITextBorderStyleRoundedRect;
    pwdTF.placeholder = @"请输入登录密码";
    pwdTF.delegate = self;
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(@35);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    // 电话
    phoneTF = [[UITextField alloc]init];
    [self.view addSubview:phoneTF];
    phoneTF.delegate = self;
    phoneTF.borderStyle = UITextBorderStyleRoundedRect;
    phoneTF.placeholder = @"请输入新手机号";
    phoneTF.hidden = YES;
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(pwdTF.mas_bottom).offset(20);
        make.height.mas_equalTo(@35);
        make.trailing.equalTo(self.view).offset(-100);
    }];
    
   
    // 验证码按钮
    codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:codeBtn];
    codeBtn.hidden = YES;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    codeBtn.backgroundColor = KNAVICOLOR;
    codeBtn.layer.cornerRadius = 4;
    [codeBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(phoneTF.mas_right).offset(5);
        make.top.height.equalTo(phoneTF);
        make.width.mas_equalTo(@80);
    }];
    
    // 验证码输入
    codeTF = [[UITextField alloc]init];
    [self.view addSubview:codeTF];
    codeTF.delegate = self;
    codeTF.hidden = YES;
    codeTF.borderStyle = UITextBorderStyleRoundedRect;
    codeTF.placeholder = @"请输入验证码";
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(phoneTF.mas_bottom).offset(20);
        make.height.mas_equalTo(@35);
        make.trailing.equalTo(self.view).offset(-20);
    }];

    // 提交
    subminBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [subminBtn setTitle:@"提交密码" forState:UIControlStateNormal];
    [self.view addSubview:subminBtn];
    subminBtn.backgroundColor = KNAVICOLOR;
    subminBtn.layer.cornerRadius = 4;
    [subminBtn addTarget:self action:@selector(matchPwd:) forControlEvents:UIControlEventTouchUpInside];
    [subminBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(phoneTF);
        make.top.equalTo(codeTF.mas_bottom).offset(30);
        make.width.equalTo(pwdTF);
        make.height.mas_equalTo(@35);
    }];

}

// 获取验证码
- (void)getCode:(UIButton *)button {
    
    if (!phoneTF.text.length) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (![Utility isValidateMobile:phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"号码无效，请重新输入"];
        return;
    }
    [DataService requestURL:@"getVcode" httpMethod:@"post" timeout:10 params:@{@"phone":phoneTF.text,@"role":@1} responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                code = [result[@"vcode"] stringValue];
                NSLog(@"%@",code);
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:button repeats:YES];
                second = 59;
                button.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1];
                [button setTitle:[NSString stringWithFormat:@"%lds重试",(long)second] forState:UIControlStateNormal];
                button.enabled = NO;
            }
            else {
                
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                phoneTF.text = @"";
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
    
}

//  定时器时间
- (void)timeAction:(NSTimer *)timer {
    
    UIButton *button = timer.userInfo;
    second--;
    [button setTitle:[NSString stringWithFormat:@"%lds重试",(long)second] forState:UIControlStateNormal];
    if (second == 0) {
        
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.backgroundColor = KNAVICOLOR;
        button.enabled = YES;
        [timer invalidate];
        timer = nil;
    }
}

// 匹配密码
- (void)matchPwd:(UIButton *)button {
    
    [SVProgressHUD showWithStatus:@"密码匹配中。。。"];
    [DataService requestURL:@"nurseLogin" httpMethod:@"post" timeout:10 params:@{@"phone":[[NSUserDefaults standardUserDefaults] objectForKey:HKHL_MEMBERPHONE], @"pwd":pwdTF.text} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                [SVProgressHUD showSuccessWithStatus:@"匹配成功"];
                [subminBtn setTitle:@"确认修改" forState:UIControlStateNormal];
                phoneTF.hidden = NO;
                codeBtn.hidden = NO;
                codeTF.hidden = NO;
                [subminBtn removeTarget:self action:@selector(matchPwd:) forControlEvents:UIControlEventTouchUpInside];
                [subminBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
                pwdTF.enabled = NO;
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

// 提交
- (void)submitAction:(UIButton *)button {
    
    [self.view endEditing:YES];
    
    if (!phoneTF.text.length) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (![Utility isValidateMobile:phoneTF.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号无效"];
        return;
    }
    
    if (!codeTF.text.length) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (![code isEqualToString:codeTF.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return;
    }
    
    [DataService requestURL:@"modNurseInfo" httpMethod:@"post" timeout:10 params:@{@"phone":phoneTF.text,@"nurse_id":[Utility getID]} responseSerializer:nil completion:^(id result, NSError *error) {
       
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                [SVProgressHUD showSuccessWithStatus:@"修改成功,请重新登录"];
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [self.navigationController performSelector:@selector(pushViewController:animated:) withObject:loginVC afterDelay:1];
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
#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == phoneTF) {
        
        if (![Utility isValidateMobile:phoneTF.text]) {
            
            [SVProgressHUD showErrorWithStatus:@"手机号无效"];
            return;
        }
    }

}
@end
