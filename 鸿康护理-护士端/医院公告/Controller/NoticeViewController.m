//
//  NoticeViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/18.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeCell.h"
#import "NoticeDetailViewController.h"
#import "MJRefresh.h"
@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *notices;
}
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"医院公告";
    self.backBtn.hidden = YES;
    [self createSubviews];
    
    // 登录成功的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadNotices) name:LOGIN_SUCCESS object:nil];
    // 修改医院成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNotices) name:MODIFY_HOSPITAL_SUCCESS object:nil];
    [self loadData ];
}

// 加载公告
- (void)loadData {
    
    if (![Utility getID]) {
        
        [SVProgressHUD showErrorWithStatus:@"登录后方能查看"];
        return;
    }
    [DataService requestURL:@"getNoticeList" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID]} responseSerializer:nil completion:^(id result, NSError *error) {
       
        [_tableView.header endRefreshing];
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@1]) {
             
                notices = result[@"list"];
                [_tableView reloadData];

            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            
            if (error.code == 3840) {
                
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                return ;
            }
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}


// 重新登录后刷新内容  
- (void)reloadNotices {
    
    [self loadData];
}

- (void)createSubviews {
    
    _tableView = [[UITableView alloc]init];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"NoticeCell" bundle:nil] forCellReuseIdentifier:@"CellID"];
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = foot;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
}

// 刷新
- (void)refreshAction {
    
    [self loadData];
}

#pragma mark -  UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return notices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.info = notices[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hidesBottomBarWhenPushed = YES;
    NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc]init];
    detailVC.ID = notices[indexPath.row][@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
