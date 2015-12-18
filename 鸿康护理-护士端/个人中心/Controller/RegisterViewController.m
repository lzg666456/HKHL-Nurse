//
//  ViewController.m
//  鸿康护理（护士端）
//
//  Created by CaiNiao on 15/11/18.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "RegisterViewController.h"
#import "SelectCell.h"
#import "Utility.h"
#import "NextRegistController.h"

@interface RegisterViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSArray *cityArray;                         // 城市数组
    NSArray *hospitalArray;                     // 医院数组
    UITextField *phoneNumber;                   // 手机号输入框
    UITextField *testNumber;                    // 验证码输入框
    UITextField *passwordText;                  // 密码输入框
    UITableView *citySelectTableView;           // 城市列表
    UITableView *hospitalSelectTableView;       // 医院列表
    UILabel *citySelect;                        // 选中城市显示
    UILabel *selectHospital;                    // 选中医院显示
    UIButton *agreeButton;                      // 协议勾选框
    NSInteger second;                           // 计时秒数
    NSString *cityID;                           // 城市ID
    NSString *hospitalID;                       // 医院ID
    NSString *Vcode;                            // 验证码
    
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.933f green:0.933f blue:0.933f alpha:1.00f];
    self.title = @"注册";
    self.navigationController.navigationBar.hidden = NO;
    
    [self _createView];
}

// 获取城市
- (void)getCity {
    
    [DataService requestURL:@"getCity" httpMethod:@"post" timeout:10 params:nil responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                cityArray = result[@"city_list"];
                citySelectTableView.hidden = NO;
                [citySelectTableView reloadData];
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

// 获取医院
- (void)getHospital {
    
    [DataService requestURL:@"getHospital" httpMethod:@"post" timeout:10 params:@{@"city_id":cityID} responseSerializer:nil completion:^(id result, NSError *error) {
       
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                hospitalArray = result[@"hospital_list"];
                hospitalSelectTableView.hidden = NO;
                [hospitalSelectTableView reloadData];
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

- (void)_createView {
    citySelect = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, self.view.width-60, 40)];
    citySelect.backgroundColor = [UIColor whiteColor];
    citySelect.textColor = [UIColor grayColor];
    citySelect.text = [cityArray firstObject];
    citySelect.textAlignment = NSTextAlignmentCenter;
    citySelect.font = [UIFont systemFontOfSize:21];
    citySelect.userInteractionEnabled = YES;
    citySelect.text = @"请选择城市";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(citySelect)];
    tap.numberOfTapsRequired = 1;
    [citySelect addGestureRecognizer:tap];
    [self.view addSubview:citySelect];
    
    UIImageView *selectImgView = [[UIImageView alloc]initWithFrame:CGRectMake(citySelect.right-30, citySelect.y+10, 20, 20)];
    selectImgView.image = [UIImage imageNamed:@"下拉_xhdpi"];
    [self.view addSubview:selectImgView];
    
    
    
    selectHospital = [[UILabel alloc]initWithFrame:CGRectMake(citySelect.left, citySelect.bottom+10, citySelect.width, 40)];
    selectHospital.text = @"请选择在职医院";
    selectHospital.textAlignment = NSTextAlignmentCenter;
    selectHospital.textColor = [UIColor grayColor];
    selectHospital.backgroundColor = [UIColor whiteColor];
    selectHospital.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectHospital)];
    [selectHospital addGestureRecognizer:tap1];
    [self.view addSubview:selectHospital];
    
    UIImageView *selectImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(selectHospital.right-30, selectHospital.y+10, 20, 20)];
    selectImgView1.image = [UIImage imageNamed:@"下拉_xhdpi"];
    [self.view addSubview:selectImgView1];
    
    
    phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(citySelect.x, selectHospital.bottom+10, selectHospital.width-80, 40)];
    phoneNumber.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"   请输入手机号码" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    phoneNumber.delegate = self;
    phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumber.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneNumber];
    
    
    UIButton *getTastWord = [UIButton buttonWithType:UIButtonTypeCustom];
    getTastWord.frame = CGRectMake(phoneNumber.right+5, phoneNumber.y, 75, 40);
    [getTastWord setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [getTastWord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getTastWord.backgroundColor = [UIColor colorWithRed:0.294f green:0.475f blue:0.925f alpha:1.00f];
    getTastWord.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    getTastWord.layer.cornerRadius = 4;
    getTastWord.titleLabel.numberOfLines = 2;
    [getTastWord addTarget:self action:@selector(getcodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getTastWord];
    
    testNumber = [[UITextField alloc]initWithFrame:CGRectMake(citySelect.x, phoneNumber.bottom+10, citySelect.width, 40)];
    testNumber.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"   请输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    testNumber.delegate = self;
    testNumber.backgroundColor = [UIColor whiteColor];
    testNumber.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:testNumber];
    
    
    passwordText = [[UITextField alloc]initWithFrame:CGRectMake(citySelect.x, testNumber.bottom+10, citySelect.width, 40)];

    passwordText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"   请设置登录密码" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];

    passwordText.delegate = self;
    passwordText.backgroundColor = [UIColor whiteColor];
    passwordText.secureTextEntry = YES;
    [self.view addSubview:passwordText];
    
    agreeButton = [[UIButton alloc]initWithFrame:CGRectMake(citySelect.x, passwordText.bottom+10, 80, 20)];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [agreeButton setTitle:@"我同意" forState:UIControlStateNormal];
    [agreeButton setImage:[UIImage imageNamed:@"未选_xhdpi"] forState:UIControlStateNormal];
    [agreeButton setImage:[UIImage imageNamed:@"已选_xhdpi"] forState:UIControlStateSelected];
    [agreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    agreeButton.selected = YES;
    [self.view addSubview:agreeButton];
    
    UIButton *registDelegate = [[UIButton alloc]initWithFrame:CGRectMake(agreeButton.right, agreeButton.y, 120, 20)];
    [registDelegate setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [registDelegate setTitle:@"《用户注册协议》" forState:UIControlStateNormal];
    registDelegate.titleLabel.font = [UIFont systemFontOfSize:14];
    [registDelegate addTarget:self action:@selector(registDelegateClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registDelegate];
    
    
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(citySelect.x, agreeButton.bottom+20, citySelect.width, 40)];
    next.backgroundColor = [UIColor colorWithRed:0.388f green:0.431f blue:0.953f alpha:1.00f];
    next.titleLabel.font = [UIFont systemFontOfSize:18];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [next addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
}


// 获取验证码
- (void)getcodeAction:(UIButton *)button {
    
    if (!phoneNumber.text.length) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (![Utility isValidateMobile:phoneNumber.text]) {
        [SVProgressHUD showErrorWithStatus:@"号码无效，请重新输入"];
        return;
    }
    [DataService requestURL:@"getVcode" httpMethod:@"post" timeout:10 params:@{@"phone":phoneNumber.text,@"role":@1} responseSerializer:nil completion:^(id result, NSError *error) {
        
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
                phoneNumber.text = @"";
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


#warning 
//下一步点击事件
- (void)nextButtonClick {
    if ([citySelect.text isEqualToString:@"请选择城市"] || [selectHospital.text isEqualToString:@"请选择在职医院"] || [phoneNumber.text isEqualToString:@""] || [testNumber.text isEqualToString:@""] || [passwordText.text isEqualToString:@""] ||agreeButton.selected == NO) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入完整内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (passwordText.text.length > 0 && passwordText.text.length < 6) {
        
        [SVProgressHUD showErrorWithStatus:@"密码过短,至少6位"];
        return;
    }
    if (passwordText.text.length > 16) {
        
        [SVProgressHUD showErrorWithStatus:@"密码过长,最长16位"];
        return;
    }
    if (![testNumber.text isEqual:Vcode]) {
        
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return;
    }
    else {
        NextRegistController *NRC = [[NextRegistController alloc]init];
        NRC.params = @{@"cityID":cityID,@"hospitalID":hospitalID,@"phone":phoneNumber.text,@"pwd":passwordText.text};
        [self.navigationController pushViewController:NRC animated:YES];
    }
}

//用户注册协议点击事件
- (void)registDelegateClick {
 
   
    
}

//我同意点击事件
- (void)agreeButtonClick:(UIButton *)button {
    button.selected = !button.selected;

}

//选择城市
- (void)citySelect {
    hospitalSelectTableView.hidden = YES;
    citySelectTableView.hidden = !citySelectTableView.hidden;
    
    if (cityArray == nil) {
        
        [self getCity];
    }
    if (citySelectTableView == nil) {
        citySelectTableView = [[UITableView alloc]initWithFrame:CGRectMake(citySelect.x, citySelect.bottom, citySelect.width, 140) style:UITableViewStylePlain];
        citySelectTableView.dataSource = self;
        citySelectTableView.delegate = self;
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = [UIColor clearColor];
        citySelectTableView.tableFooterView = foot;
        [citySelectTableView registerClass:[SelectCell class] forCellReuseIdentifier:@"selected_cell"];
        [self.view addSubview:citySelectTableView];
        citySelectTableView.hidden = YES;
    
    }
}

//选择医院
- (void)selectHospital {
    citySelectTableView.hidden = YES;
    hospitalSelectTableView.hidden = !hospitalSelectTableView.hidden;
    if (cityID == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
        return;
    }
    hospitalArray = nil;
    if (!hospitalSelectTableView.hidden) {
        
        [self getHospital];
    }
    if (hospitalSelectTableView == nil) {
        hospitalSelectTableView = [[UITableView alloc]initWithFrame:CGRectMake(selectHospital.x, selectHospital.bottom, selectHospital.width, 140) style:UITableViewStylePlain];
        hospitalSelectTableView.dataSource = self;
        hospitalSelectTableView.delegate = self;
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = [UIColor clearColor];
        hospitalSelectTableView.tableFooterView = foot;
        [hospitalSelectTableView registerClass:[SelectCell class] forCellReuseIdentifier:@"hospital_cell"];
        [self.view addSubview:hospitalSelectTableView];
        hospitalSelectTableView.hidden = YES;
    }
}



#pragma mark - UITextField delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

     if (textField == phoneNumber) {
        if (![Utility isValidateMobile:textField.text] && textField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        }
        
    }

    return YES;
}



#pragma mark tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == citySelectTableView){
        return cityArray.count;
    }
    return hospitalArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == citySelectTableView) {
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selected_cell"];
        cell.textstring = cityArray[indexPath.row][@"class_name"];
        return cell;
    }
    else if (tableView == hospitalSelectTableView) {
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hospital_cell"];
        cell.textstring = hospitalArray[indexPath.row][@"name"];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == citySelectTableView) {
        citySelect.text = cityArray[indexPath.row][@"class_name"];
        if(![cityArray[indexPath.row][@"class_id"] isEqualToString:cityID]) {
            
            selectHospital.text = @"请选择在职医院";
        }
        cityID = cityArray[indexPath.row][@"class_id"];
        citySelectTableView.hidden = YES;
    }
    else if (tableView == hospitalSelectTableView) {
        selectHospital.text = hospitalArray[indexPath.row][@"name"];
        hospitalID = hospitalArray[indexPath.row][@"id"];
        hospitalSelectTableView.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
