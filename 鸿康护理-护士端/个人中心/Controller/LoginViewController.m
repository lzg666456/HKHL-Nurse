//
//  LoginViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/18.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "LoginViewController.h"
#import "FindPwdViewController.h"
#import "UserHomeViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UIButton *rememberBtn;
    UITextField *phoneTF;
    UITextField *pwdTF;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"登录";
    self.backBtn.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)createSubViews {
    
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage imageNamed:@"背景_xxhdpi"];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.top.trailing.bottom.equalTo(self.view).offset(0);
    }];
    
    UIImageView *logo = [[UIImageView alloc]init];
    logo.image = [UIImage imageNamed:@"LOGO_xxhdpi"];
    [bgView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.view.top+10);
        make.height.mas_equalTo(self.view.height*0.4);
        make.width.equalTo(logo.mas_height);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIView *nameView = [[UIView alloc]init];
    nameView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(logo.mas_bottom);
        make.width.mas_equalTo(self.view.width*0.8);
        make.height.mas_equalTo(@45);
        make.centerX.equalTo(logo.mas_centerX);
    }];
    
    UIImageView *userImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"用户名_xxhdpi"]];
    [nameView addSubview:userImg];
    [userImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.top.equalTo(nameView).offset(5);
        make.bottom.equalTo(nameView).offset(-5);
        make.width.equalTo(userImg.mas_height);
    }];
    
    phoneTF = [[UITextField alloc]init];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    phoneTF.placeholder = @"       手机号";
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.delegate = self;
    phoneTF.tag = 1;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:REMEMBERPHONR]) {
        
        phoneTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:REMEMBERPHONR];
    }
    [nameView addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.trailing.bottom.equalTo(nameView);
        make.leading.equalTo(userImg.mas_right).offset(5);
    }];
    
    UIView *pwdView = [[UIView alloc]init];
    pwdView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:pwdView];
    [pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameView.mas_bottom).offset(10);
        make.width.mas_equalTo(self.view.width*0.8);
        make.height.mas_equalTo(@45);
        make.centerX.equalTo(logo.mas_centerX);
    }];
    
    UIImageView *pwdImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码_xxhdpi"]];
    [pwdView addSubview:pwdImg];
    [pwdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.top.equalTo(pwdView).offset(5);
        make.bottom.equalTo(pwdView).offset(-5);
        make.width.equalTo(pwdImg.mas_height);
    }];
    
    pwdTF = [[UITextField alloc]init];
    pwdTF.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    pwdTF.placeholder = @"       请输入登录密码";
    pwdTF.delegate = self;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.tag = 2;
    pwdTF.secureTextEntry = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:REMEMBERPWD]) {
        
        pwdTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:REMEMBERPWD];
    }
    [pwdView addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.trailing.bottom.equalTo(pwdView);
        make.leading.equalTo(pwdImg.mas_right).offset(5);
    }];
    
    rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rememberBtn setImage:[UIImage imageNamed:@"未选_xxhdpi"] forState:UIControlStateNormal];
    [rememberBtn setImage:[UIImage imageNamed:@"已选_xxhdpi"] forState:UIControlStateSelected];
    rememberBtn.selected = YES;
    [rememberBtn addTarget:self action:@selector(rememberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberBtn];
    [rememberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(pwdView.mas_leading);
        make.width.height.mas_equalTo(@20);
        make.top.equalTo(pwdView.mas_bottom).offset(15);
    }];
    
    UILabel *rememberLabel = [[UILabel alloc]init];
    rememberLabel.text = @"记住我";
    rememberLabel.textColor = [UIColor whiteColor];
    rememberLabel.font = [UIFont systemFontOfSize: FONT_SIZE_MIDDLE];
    [bgView addSubview:rememberLabel];
    [rememberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(rememberBtn.mas_right).offset(7);
        make.top.equalTo(rememberBtn);
        make.height.equalTo(rememberBtn);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 4;
    loginBtn.backgroundColor = KNAVICOLOR;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.trailing.equalTo(pwdView);
        make.top.equalTo(rememberBtn.mas_bottom).offset(30);
        make.height.mas_equalTo(@40);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = KNAVICOLOR;
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@2);
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(loginBtn.mas_bottom).offset(20);
    }];

    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:KNAVICOLOR forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1];
    [forgetBtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(line);
        make.trailing.equalTo(line.mas_leading);
        make.width.mas_equalTo(@100);
        make.height.equalTo(line);
    }];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"注册会员" forState:UIControlStateNormal];
    [registerBtn setTitleColor:KNAVICOLOR forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line);
        make.leading.equalTo(line.mas_trailing);
        make.width.mas_equalTo(@100);
        make.height.equalTo(line);
    }];
}

#warning 登录
// 登录
- (void)loginAction {
    
    [self.view endEditing:YES];

    if (!phoneTF.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (![Utility isValidateMobile:phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if (!pwdTF.text.length) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (pwdTF.text.length < 6) {
        
        [SVProgressHUD showErrorWithStatus:@"密码过短,请重新输入"];
        return;
    }

    [DataService requestURL:@"nurseLogin" httpMethod:@"post" timeout:10 params:@{@"phone":phoneTF.text, @"pwd":pwdTF.text} responseSerializer:nil completion:^(id result, NSError *error) {
       
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:result[@"nurse"][@"nurse_id"] forKey:HKHL_MEMBERID];
                [[NSUserDefaults standardUserDefaults] setObject:result[@"nurse"][@"phone"] forKey:HKHL_MEMBERPHONE];
                [[NSUserDefaults standardUserDefaults] setObject:result[@"nurse"][@"username"] forKey:HKHL_USERNAME];
                [[NSUserDefaults standardUserDefaults] setObject:result[@"nurse"][@"title"] forKey:HKHL_TITLE];
                [[NSUserDefaults standardUserDefaults] setObject:result[@"nurse"][@"avatar"] forKey:HKHL_AVATAR];
                if (rememberBtn.selected) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:phoneTF.text forKey:REMEMBERPHONR];
                    [[NSUserDefaults standardUserDefaults] setObject:pwdTF.text forKey:REMEMBERPWD];
                }
                else {
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REMEMBERPHONR];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REMEMBERPWD];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                UserHomeViewController *userVC = [[UserHomeViewController alloc]init];
                userVC.simpleInfo = result[@"nurse"];
                [self.navigationController pushViewController:userVC animated:YES];
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

- (void)rememberAction:(UIButton *)button {
    
    button.selected = !button.selected;
}

// 忘记密码点击
- (void)forgetAction {
 
    FindPwdViewController *findVC = [[FindPwdViewController alloc]init];
    [self.navigationController pushViewController:findVC animated:YES];
}

// 注册会员单击
- (void)registerAction {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1) {
        
        if (![Utility isValidateMobile:textField.text]) {
            
            [SVProgressHUD showErrorWithStatus:@"电话号码无效"];
            return;
        }
    }
    else {
        
        if (textField.text.length < 6 && textField.text.length > 0) {
            
            [SVProgressHUD showErrorWithStatus:@"密码过短,请重新输入"];
        }
    }
}

@end
