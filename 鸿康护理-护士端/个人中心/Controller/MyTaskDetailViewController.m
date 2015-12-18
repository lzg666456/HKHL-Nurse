//
//  MyTaskDetailViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/21.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "MyTaskDetailViewController.h"
#import "SDCycleScrollView.h"
#import "MapViewController.h"
@interface MyTaskDetailViewController ()
{
    UIButton *right;
    NSDictionary *info;
    UIButton *refuseBtn;
    UIButton *enrollBtn;
    UIView *bottom;
    NSString *collect_id;
}
@end

@implementation MyTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"任务详情";
    
    [self loadData];
}

- (void)loadData {
    
    
    [DataService requestURL:@"getNurseTaskInfo" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"task_id":_ID} responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                info = result[@"task_info"];
                [self createSubviews];
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

- (void)createSubviews {
    
    right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 40, 40);
    [right addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    [right setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    [right setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    if (![@([info[@"collect_id"] integerValue]) isEqualToNumber:@0]) {
        right.selected = YES;
    }
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
        
    }];
        UIView *container = [[UIView alloc]init];
    [scroll addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.top.trailing.bottom.equalTo(scroll);
        make.width.equalTo(scroll);
    }];
    
    NSData *jsonData = [info[@"sub_pic"] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    SDCycleScrollView *postImg = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*0.66)];
    [container addSubview:postImg];
    postImg.imageURLStringsGroup = arr;
    postImg.placeholderImage = [UIImage imageNamed:@"主图_xxhdpi"];
    [postImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.top.equalTo(container);
        make.height.mas_equalTo(self.view.width*0.66);
        make.width.mas_equalTo(self.view.width);
    }];
    
    UILabel *orange = [[UILabel alloc]init];
    orange.backgroundColor = [UIColor orangeColor];
    [container addSubview:orange];
    [orange mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(postImg);
        make.top.equalTo(postImg.mas_bottom).offset(15);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@5);
        
    }];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_LARGE];
    titleLabel.text = info[@"subject"];
    [container addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.view).offset(-10);
        make.top.equalTo(orange);
        make.leading.equalTo(orange.mas_trailing).offset(20);
    }];
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor darkGrayColor];
    
    NSString *current = [Utility timeintervalToDate:[[NSDate date] timeIntervalSince1970] Formatter:@"yy年MM月dd日 hh:mm"];
    NSString *begin = [Utility timeintervalToDate:[info[@"begintime"] doubleValue] Formatter:@"yy年MM月dd日 hh:mm"];
    if ([[current substringToIndex:2] isEqualToString:[begin substringToIndex:4]]) {
        begin = [Utility timeintervalToDate:[info[@"begintime"] doubleValue] Formatter:@"MM月dd日 hh:mm"];
    }
    NSString *end ;
    if ([info[@"endtime"] isEqualToString:@"0"]) {
        
        end = @"无限期";
    }
    else {
        end = [Utility timeintervalToDate:[info[@"endtime"] doubleValue] Formatter:@"yy年MM月dd日 hh:mm"];
        if ([[current substringToIndex:2] isEqualToString:[end substringToIndex:4]]) {
            end = [Utility timeintervalToDate:[info[@"begintime"] doubleValue] Formatter:@"MM月dd日 hh:mm"];
        }
    }

    timeLabel.text = [NSString stringWithFormat:@"时间 %@-%@",begin,end];
    timeLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    [container addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.trailing.equalTo(container).offset(-10);
        make.height.mas_equalTo(@20);
        
    }];
    
    // 地点
    UILabel *address = [[UILabel alloc]init];
    address.text = [NSString stringWithFormat:@"地点：%@",info[@"address"]];
    address.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    address.textColor = [UIColor darkGrayColor];
//    CGRect re = [address.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_MIDDLE]} context:nil];
    [container addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(timeLabel);
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
//        make.width.mas_equalTo(re.size.width+20);
        make.height.equalTo(timeLabel);
    }];
    
    // 酬劳
    UILabel *rewardLabel = [[UILabel alloc]init];
    rewardLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    rewardLabel.textColor = [UIColor darkGrayColor];
    rewardLabel.text = [NSString stringWithFormat:@"酬劳：%@",info[@"commission"]];
    if ([info[@"commission"] isEqualToString:@""]) {
        
        rewardLabel.text = [NSString stringWithFormat:@"酬劳：无酬劳"];
    }
    [container addSubview:rewardLabel];
    [rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(address.mas_bottom).offset(5);
        make.leading.trailing.equalTo(address);
        make.height.mas_equalTo(@20);
        
    }];
    
    if (_isActivity) {
        
        rewardLabel.hidden = YES;
        [rewardLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(@0);
        }];
    }

    
    //定位按钮
    UIButton *locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locBtn setImage:[UIImage imageNamed:@"地图定位_xxhdpi"] forState:UIControlStateNormal];
    [container addSubview:locBtn];
    [locBtn addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    [locBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(address);
        make.leading.equalTo(address.mas_trailing).offset(5);
        make.width.mas_equalTo(@15);
        make.height.equalTo(@20);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    label.text = @"报名人数：";
    label.hidden = YES;
    if (_taskType == MyAttend) {
        
        label.text = @"参加人数：";
    }
    if (_taskType == Myassigned) {
        
        label.text = @"指派人数";
    }
    label.textColor = [UIColor darkGrayColor];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(address);
        make.top.equalTo(rewardLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(@0);
    }];
    
    // 人数
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    countLabel.textColor = KNAVICOLOR;
    countLabel.text = [NSString stringWithFormat:@"%@人",info[@"number"]];
    [container addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(label);
        make.leading.equalTo(label.mas_trailing).offset(5);
        make.height.equalTo(@0);
        make.width.mas_equalTo(@100);
    }];
    countLabel.hidden = YES;
    
    
    // 详情
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.numberOfLines = 0;
    contentLabel.text = [NSString stringWithFormat:@"详情：%@",info[@"content"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:3];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentLabel.text length])];
    contentLabel.attributedText = attributedString;
    [container addSubview:contentLabel];
    //    CGRect rect = [contentLabel.text boundingRectWithSize:CGSizeMake(self.view.width-30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:    @{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1],NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(timeLabel);
        make.top.equalTo(label.mas_bottom).offset(5);
        //        make.height.mas_equalTo(rect.size.height+10);
        
    }];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(contentLabel).offset(20);
    }];
    
    
    // ------------------------------bottom---------------------
    bottom = [[UIView alloc]init];
    bottom.backgroundColor = KNAVICOLOR;
    [self.view addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(scroll.mas_bottom);
    }];
    
    // 被指派的
    if (_taskType == Myassigned) {
//        "verify_status":"参加确认状态 0:未确认 1:已确认 2:已否定"},
        if ([info[@"relation"][@"verify_status"] isEqualToString:@"0"]) {
            
            // 拒绝
            refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [refuseBtn setBackgroundImage:[UIImage imageNamed:@"我要报名框_xxhdpi"] forState:UIControlStateNormal];
            [refuseBtn addTarget:self action:@selector(RefuseAction) forControlEvents:UIControlEventTouchUpInside];
            [bottom addSubview:refuseBtn];
            [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(bottom);
                make.height.mas_equalTo(@35);
                make.width.equalTo(@100);
                make.leading.equalTo(bottom).offset(30);
            }];
            
            // 接受报名
            enrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            [enrollBtn setTitle:@"接受" forState:UIControlStateNormal];
            [enrollBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [enrollBtn setBackgroundImage:[UIImage imageNamed:@"我要报名框_xxhdpi"] forState:UIControlStateNormal];
            [enrollBtn addTarget:self action:@selector(AgreeAction) forControlEvents:UIControlEventTouchUpInside];
            [bottom addSubview:enrollBtn];
            [enrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(bottom);
                make.height.mas_equalTo(@35);
                make.width.equalTo(@100);
                make.trailing.equalTo(bottom).offset(-30);
            }];
            
        }
        else {
            
            UIImageView *enrollFlag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"心_xxhdpi"]];
            [bottom addSubview:enrollFlag];
            [enrollFlag mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(bottom);
                make.leading.equalTo(bottom).offset(30);
                make.width.height.mas_equalTo(@15);
            }];
            
            // 报名人数
            UILabel *countLabel = [[UILabel alloc]init];
            countLabel.text = [NSString stringWithFormat:@"%@人被指派",info[@"number"]];
            countLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
            countLabel.textColor= [UIColor whiteColor];
            [bottom addSubview:countLabel];
            [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(bottom);
                make.leading.equalTo(enrollFlag.mas_right).offset(5);
                make.height.equalTo(@20);
                make.width.equalTo(@150);
            }];
            
            // 我要报名
            enrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([info[@"relation"][@"verify_status"] isEqualToString:@"1"]) {
                [enrollBtn setTitle:@"已接受" forState:UIControlStateNormal];
            }
            else {
                [enrollBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            }
            [enrollBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [enrollBtn setBackgroundImage:[UIImage imageNamed:@"已报名&已参加&已被指派_xxhdpi"] forState:UIControlStateNormal];
            enrollBtn.enabled = NO;
            [bottom addSubview:enrollBtn];
            [enrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(bottom);
                make.height.mas_equalTo(@35);
                make.width.equalTo(@100);
                make.trailing.equalTo(bottom).offset(-30);
            }];

        }
    }
    
    else {
        
        UIImageView *enrollFlag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"心_xxhdpi"]];
        [bottom addSubview:enrollFlag];
        [enrollFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(bottom);
            make.leading.equalTo(bottom).offset(30);
            make.width.height.mas_equalTo(@15);
        }];
        
        // 报名人数
        UILabel *countLabel = [[UILabel alloc]init];
        countLabel.text = [NSString stringWithFormat:@"%@人报名",info[@"number"]];
        countLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
        countLabel.textColor= [UIColor whiteColor];
        [bottom addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(bottom);
            make.leading.equalTo(enrollFlag.mas_right).offset(5);
            make.height.equalTo(@20);
            make.width.equalTo(@150);
        }];
        
        // 我要报名
        enrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [enrollBtn setTitle:@"已报名" forState:UIControlStateNormal];
        [enrollBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [enrollBtn setBackgroundImage:[UIImage imageNamed:@"已报名&已参加&已被指派_xxhdpi"] forState:UIControlStateNormal];
        enrollBtn.enabled = NO;
        [bottom addSubview:enrollBtn];
        [enrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(bottom);
            make.height.mas_equalTo(@35);
            make.width.equalTo(@100);
            make.trailing.equalTo(bottom).offset(-30);
        }];

        // 参加的
        if (_taskType == MyAttend) {
            
            countLabel.text = [NSString stringWithFormat:@"%@人参加",info[@"number"]];
            [enrollBtn setTitle:@"已参加" forState:UIControlStateNormal];
        }
    }
   

}

// 拒绝
- (void)RefuseAction {
    [DataService requestURL:@"checkTaskAssign" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"task_id":_ID,@"status":@2} responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                refuseBtn.hidden = YES;
                UIImageView *enrollFlag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"心_xxhdpi"]];
                [bottom addSubview:enrollFlag];
                [enrollFlag mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerY.equalTo(bottom);
                    make.leading.equalTo(bottom).offset(30);
                    make.width.height.mas_equalTo(@15);
                }];
                
                // 报名人数
                UILabel *countLabel = [[UILabel alloc]init];
                countLabel.text = [NSString stringWithFormat:@"%@人被指派",info[@"number"]];
                countLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
                countLabel.textColor= [UIColor whiteColor];
                [bottom addSubview:countLabel];
                [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerY.equalTo(bottom);
                    make.leading.equalTo(enrollFlag.mas_right).offset(5);
                    make.height.equalTo(@20);
                    make.width.equalTo(@150);
                }];
                
                [enrollBtn setBackgroundImage:[UIImage imageNamed:@"已报名&已参加&已被指派_xxhdpi"] forState:UIControlStateNormal];
                enrollBtn.enabled = NO;
                [enrollBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ASSIGNFINISHED object:nil];
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

// 同意
- (void)AgreeAction {
    [DataService requestURL:@"checkTaskAssign" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"task_id":_ID,@"status":@1} responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                refuseBtn.hidden = YES;
                UIImageView *enrollFlag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"心_xxhdpi"]];
                [bottom addSubview:enrollFlag];
                [enrollFlag mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerY.equalTo(bottom);
                    make.leading.equalTo(bottom).offset(30);
                    make.width.height.mas_equalTo(@15);
                }];
                
                // 报名人数
                UILabel *countLabel = [[UILabel alloc]init];
                countLabel.text = [NSString stringWithFormat:@"%@人被指派",info[@"number"]];
                countLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
                countLabel.textColor= [UIColor whiteColor];
                [bottom addSubview:countLabel];
                [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerY.equalTo(bottom);
                    make.leading.equalTo(enrollFlag.mas_right).offset(5);
                    make.height.equalTo(@20);
                    make.width.equalTo(@150);
                }];
                
                [enrollBtn setBackgroundImage:[UIImage imageNamed:@"已报名&已参加&已被指派_xxhdpi"] forState:UIControlStateNormal];
                enrollBtn.enabled = NO;
                [enrollBtn setTitle:@"已同意" forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter] postNotificationName:ASSIGNFINISHED object:nil];
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

// 关注或取消
- (void)followAction:(UIButton *)button {
    
    NSString *module_id;
    if (_isActivity) {
        
        module_id = @"1";
    }
    else {
        module_id = @"2";
    }
    if (!button.selected) {
        //        输入：{“nurse_id”:”护士ID”, “module_id”：“收藏模块ID 1:活动 2:任务”, “module_model_id”：“任务/活动ID”}
        
        
        [DataService requestURL:@"addNurseCollect" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"module_id":module_id,@"module_model_id":_ID} responseSerializer:nil completion:^(id result, NSError *error) {
            
            if (error == nil) {
                
                if ([result[@"err"] isEqualToNumber:@0]) {
                    
                    collect_id = [result[@"collect_id"] stringValue];
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    button.selected = YES;
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
        if (collect_id == nil) {
            
            collect_id = info[@"collect_id"];
        }
        //        输入：{“nurse_id”:”护士ID”, “collect_id”：“收藏ID 数组”}
        [DataService requestURL:@"delNurseCollect" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"collect_id":collect_id} responseSerializer:nil completion:^(id result, NSError *error) {
            
            if (error == nil) {
                
                if ([result[@"err"] isEqualToNumber:@0]) {
                    
                    button.selected = NO;
                    [SVProgressHUD showErrorWithStatus:@"取消收藏成功"];
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

// 定位
- (void)location:(UIButton *)button {
    
    self.hidesBottomBarWhenPushed = YES;
    MapViewController *mapVC = [[MapViewController alloc]init];
    mapVC.lng = info[@"address_lng"];
    mapVC.lat = info[@"address_lat"];
    mapVC.address = info[@"address"];
    [self.navigationController pushViewController:mapVC animated:YES];
}
@end
