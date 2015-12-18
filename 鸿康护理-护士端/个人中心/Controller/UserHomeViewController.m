//
//  UserInfoViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/18.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "UserHomeViewController.h"
#import "UserInfoViewController.h"
#import "ChangePwdViewController.h"
#import "MyCollectionController.h"
#import "MyTaskViewController.h"
#import "CertificatesViewController.h"
#import "MyActivityViewController.h"
#import "ChangePhoneController.h"
#import "MJRefresh.h"
@interface UserHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titles;
    NSArray *_images;
    UIImageView *headImg;
    NSInteger number;
    UILabel *numLabel;
    UILabel *newLabel;
    UIScrollView *scroll;
}
@end

@implementation UserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.backBtn.hidden = YES;
    _titles = @[@"我的任务",@"我的活动",@"我的收藏",@"我的资料",@"修改密码",@"职业认证"];
    _images = @[@"我的任务_xxhdpi",@"我的活动_xxhdpi",@"我的收藏_xxhdpi",@"个人信息_xxhdpi",@"修改密码_xxhdpi",@"认证_xxhdpi"];
    [self createSubviews];
}

- (void)createSubviews {
  
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = KNAVICOLOR;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.top.trailing.equalTo(self.view);
        make.height.mas_equalTo(self.view.width*0.1);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom);
        make.height.mas_equalTo(self.view.width*0.13);

    }];
    
    // 头像
    headImg = [[UIImageView alloc]init];
    headImg.frame = CGRectMake(20, topView.top, self.view.width*0.2, self.view.width*0.2);
    headImg.layer.cornerRadius = headImg.width*0.5;
    headImg.layer.masksToBounds = YES;
    headImg.layer.borderColor = KNAVICOLOR.CGColor;
    headImg.layer.borderWidth = 1.5;
    [self.view addSubview:headImg];
//    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.equalTo(self.view).offset(20);
//        make.height.width.mas_equalTo(self.view.width*0.2);
//        make.top.equalTo(topView);
//    }];
    

    // ID
    UILabel *IDLabel = [[UILabel alloc]init];
    IDLabel.text = [NSString stringWithFormat:@"ID:%@",[[NSUserDefaults standardUserDefaults] objectForKey:HKHL_MEMBERPHONE]];
    IDLabel.textColor = [UIColor whiteColor];
    IDLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1];
    [topView addSubview:IDLabel];
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(headImg.mas_trailing).offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
        make.bottom.equalTo(topView).offset(-5);
    }];
    
    
    UIButton *changePhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [changePhone setTitle:@"修改手机号" forState:UIControlStateNormal];
    changePhone.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    [changePhone setBackgroundImage:[UIImage imageNamed:@"我要报名框_xxhdpi"] forState:UIControlStateNormal];
    [changePhone addTarget:self action:@selector(changePhoneAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:changePhone];
    [changePhone mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.trailing.equalTo(topView).offset(-20);
        make.top.equalTo(IDLabel).offset(-5);
        make.height.equalTo(IDLabel).offset(5);
        make.width.mas_equalTo(@80);
    }];
    
    
    // 姓名
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = KNAVICOLOR;
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:HKHL_USERNAME];
    nameLabel.font = [UIFont systemFontOfSize:FONT_SIZE_LARGE+2];
    [bottomView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(IDLabel);
        make.centerY.equalTo(bottomView);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
    }];
    
    // 职称
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:HKHL_TITLE];
    titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    [bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(nameLabel.mas_trailing);
        make.bottom.equalTo(nameLabel);
        make.height.equalTo(@30);
        make.width.mas_equalTo(self.view.width-nameLabel.right);
    }];
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.width*0.23, self.view.width, _titles.count *45+100)];
    scroll.contentSize = CGSizeMake(scroll.width, scroll.height +130);
    scroll.showsVerticalScrollIndicator = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, scroll.width-20, _titles.count*45)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELLID"];
    scroll.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = foot;
    _tableView.layer.cornerRadius = 6;
    _tableView.bounces = NO;

    [scroll addSubview:_tableView];
}

// 更换手机号
- (void)changePhoneAction {
    
    self.hidesBottomBarWhenPushed = YES;
    ChangePhoneController *cphoneVC = [[ChangePhoneController alloc]init];
    [self.navigationController pushViewController:cphoneVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)refreshAction {
    
    [DataService requestURL:@"countNurseAssignTask" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID]} responseSerializer:nil completion:^(id result, NSError *error) {
        
        [scroll.header endRefreshing];
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                number = [result[@"number"] integerValue];
                if (number > 0) {
                    
                    numLabel.hidden = NO;
                    newLabel.hidden = NO;
                    numLabel.text = result[@"number"];
                }
                else {
                    numLabel.hidden = YES;
                    newLabel.hidden = YES;
                }
            }
            else {
                //                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            //            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,[[NSUserDefaults standardUserDefaults] objectForKey:HKHL_AVATAR]]] placeholderImage:[UIImage imageNamed:@"头像_xxhdpi"]];
    [self.view bringSubviewToFront:headImg];
    [self refreshAction];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:_images[indexPath.row]];
    [cell.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.top.equalTo(cell.contentView).offset(10);
        make.bottom.equalTo(cell).offset(-10);
        make.width.equalTo(imgView.mas_height);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = _titles[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(imgView.mas_trailing).offset(10);
        make.centerY.equalTo(cell.contentView);
        make.height.mas_equalTo(@20);
        
    }];
    if (indexPath.row == 0) {
        
        numLabel = [[UILabel alloc]init];
        numLabel.text = _simpleInfo[@"task"][@"num"];
        numLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
        [cell.contentView addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.trailing.equalTo(cell.contentView);
            make.centerY.equalTo(cell.contentView);
            
        }];
        
        newLabel = [[UILabel alloc]init];
        newLabel.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:newLabel];
        [newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(numLabel.mas_trailing);
            make.top.equalTo(numLabel).offset(-3);
            make.height.width.equalTo(@6);
        }];
        newLabel.layer.cornerRadius = 3;
        newLabel.clipsToBounds = YES;
        if ([_simpleInfo[@"task"][@"unread"] floatValue] <= 0) {
            
            numLabel.hidden = YES;
            newLabel.hidden = YES;
           
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.row) {
            // 我的任务
        case 0:
        {
            MyTaskViewController *mytaskVC = [[MyTaskViewController alloc]init];
            mytaskVC.number = number;
            [self.navigationController pushViewController:mytaskVC animated:YES];
        }
            break;
            // 我的活动
        case 1:
        {
            MyActivityViewController *activityVC = [[MyActivityViewController alloc]init];
            [self.navigationController pushViewController:activityVC animated:YES];
        }
            break;
            // 我的收藏
        case 2:
        {
            MyCollectionController *collectVC = [[MyCollectionController alloc]init];
            [self.navigationController pushViewController:collectVC animated:YES];
        }
            break;
            // 个人信息
        case 3:
        {
            UserInfoViewController *userinfoVC = [[UserInfoViewController alloc]init];
            [self.navigationController pushViewController:userinfoVC animated:YES];
        }
            break;
            // 修改密码
        case 4:
        {
            ChangePwdViewController *changeVC = [[ChangePwdViewController alloc]init];
            [self.navigationController pushViewController:changeVC animated:YES];
        }
            break;
            // 职业认证
        default: {
            
            CertificatesViewController *certificatesVC = [[CertificatesViewController alloc]init];
            [self.navigationController pushViewController:certificatesVC animated:YES];
        }
    }
    self.hidesBottomBarWhenPushed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == scroll) {
        
        if (scrollView.contentOffset.y >= 0) {
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
        if (scrollView.contentOffset.y <= -70) {
            [scrollView setContentOffset:CGPointMake(0, -70)];
        }
    }
}
@end
