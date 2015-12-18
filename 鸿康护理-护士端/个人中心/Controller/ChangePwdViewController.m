//
//  ChangePwdViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/18.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "LoginViewController.h"
@interface ChangePwdViewController ()
{
    UITextField *oldTF;
    UITextField *newTF;
    UITextField *reTF;
}
@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"修改密码";
    [self createSubviews];
}

- (void)createSubviews {
    
    oldTF = [[UITextField alloc]init];
    oldTF.borderStyle = UITextBorderStyleRoundedRect;
    oldTF.placeholder = @"原密码";
    oldTF.secureTextEntry = YES;
    [self.view addSubview:oldTF];
    [oldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(20);
        make.width.mas_equalTo(self.view.width-40);
        make.height.mas_equalTo(@35);

    }];
    
    if (_isFind) {
        
        [oldTF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.top.equalTo(self.view);
        }];
    }
    
    newTF = [[UITextField alloc]init];
    newTF.borderStyle = UITextBorderStyleRoundedRect;
    newTF.secureTextEntry = YES;
    newTF.placeholder = @"新密码";
    [self.view addSubview:newTF];
    [newTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(oldTF.mas_bottom).offset(20);
        make.width.mas_equalTo(self.view.width-40);
        make.height.mas_equalTo(@35);
    }];
    
    reTF = [[UITextField alloc]init];
    reTF.borderStyle = UITextBorderStyleRoundedRect;
    reTF.secureTextEntry = YES;
    reTF.placeholder = @"确认新密码";
    [self.view addSubview:reTF];
    [reTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(newTF.mas_bottom).offset(20);
        make.width.mas_equalTo(self.view.width-40);
        make.height.mas_equalTo(@35);
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 4;
    submitBtn.backgroundColor = KNAVICOLOR;
    [self.view addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(reTF.mas_bottom).offset(30);
        make.width.mas_equalTo(self.view.width-40);
        make.height.mas_equalTo(@35);
    }];
}

// 提交
- (void)submitAction {
    
    if (!_isFind) {
        
        if (!oldTF.text.length) {
            
            [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
            return;
        }
    }
    
    if (!newTF.text.length) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if (newTF.text.length < 6) {
        
        [SVProgressHUD showErrorWithStatus:@"密码过短,至少6位"];
        return;
    }
    if (newTF.text.length < 6) {
        
        [SVProgressHUD showErrorWithStatus:@"密码过短,最长16位"];
        return;
    }

    if ([newTF.text isEqualToString:oldTF.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"新密码与旧密码不能一样"];
        return;
    }
    if (!reTF.text.length) {
        
        [SVProgressHUD showErrorWithStatus:@"请确认新密码"];
        return;
    }
    if (![reTF.text isEqualToString:newTF.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"密码输入不一致"];
        return;
    }
    
    if (_isFind) {
        
        [DataService requestURL:@"resetNursePassword" httpMethod:@"post" timeout:10 params:@{@"phone":_phone,@"new":newTF.text} responseSerializer:nil completion:^(id result, NSError *error) {
            
            if (error == nil) {
                
                if ([result[@"err"] isEqualToNumber:@0]) {
                    
                    [SVProgressHUD showSuccessWithStatus:result[@"msg"]];
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
    else {
        
        [DataService requestURL:@"modNursePassword" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[[NSUserDefaults standardUserDefaults] objectForKey:HKHL_MEMBERID],@"old":oldTF.text,@"new":newTF.text} responseSerializer:nil completion:^(id result, NSError *error) {
            
            if (error == nil) {
                
                if ([result[@"err"] isEqualToNumber:@0]) {
                    
                    [SVProgressHUD showSuccessWithStatus:result[@"msg"]];
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
    
}

@end
