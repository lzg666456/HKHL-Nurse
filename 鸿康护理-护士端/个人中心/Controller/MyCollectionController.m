//
//  MyCollectionControllerViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/19.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "MyCollectionController.h"
#import "MyTaskDetailViewController.h"
#import "TaskDetailViewController.h"
#import "MJRefresh.h"
#import "mycollectCell.h"
@interface MyCollectionController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_collections;

}
@end

@implementation MyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self loadData];
}

// 加载数据
- (void)loadData {
    
    [DataService requestURL:@"getNurseCollect" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID]} responseSerializer:nil completion:^(id result, NSError *error) {
       
        _collections = nil;
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                _collections = result[@"collect_list"];
                [self createSubviews];
                [_tableView reloadData];
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

// 加载视图
- (void)createSubviews {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MyCollectCell" bundle:nil] forCellReuseIdentifier:@"MyCollectCell"];
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        _tableView.backgroundColor = [UIColor clearColor];
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = foot;
    }
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.trailing.top.bottom.equalTo(self.view);
    }];
}

// 刷新
- (void)refreshAction {
    
    [DataService requestURL:@"getNurseCollect" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID]} responseSerializer:nil completion:^(id result, NSError *error) {
        
        [_tableView.header endRefreshing];
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                _collections = result[@"collect_list"];
                [_tableView reloadData];
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

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _collections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectCell" forIndexPath:indexPath];
    cell.isCollect = YES;
    cell.info = _collections[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hidesBottomBarWhenPushed = YES;
    TaskDetailViewController *detailVC = [[TaskDetailViewController alloc]init];
    detailVC.ID = _collections[indexPath.row][@"id"];
    // 活动
    if ([_collections[indexPath.row][@"module_id"] isEqualToNumber:@1]) {
        
        detailVC.isActivity = YES;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
//    “module_id”:”收藏模块：1:活动 2:任务”,
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_tableView removeFromSuperview];
}

@end
