//
//  MyActivityViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/25.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "MyActivityViewController.h"
#import "HMSegmentedControl.h"
#import "MyCollectCell.h"
#import "TaskDetailViewController.h"
#import "MJRefresh.h"
@interface MyActivityViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    HMSegmentedControl *_segment;
    UIScrollView *_scroll;
    UITableView *_enrollTable;  // 报名列表
    UITableView *_attendTable;  // 参加列表
    UITableView *_assingTable;  // 被指派列表
    NSArray *_enrollArr;
    NSArray *_attendArr;
    NSArray *_assingArr;
    NSInteger _limit;

}
@end

@implementation MyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的活动";
    [self loadDataWithLimit:0];
    [self createSubviews];
}

/**
 *  获取数据
 *
 *  @param type  类型
 *  @param limit 时间范围
 */
- (void)loadDataWithLimit:(NSInteger)limit {
    
    [DataService requestURL:@"getNurseActivity" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"limit":@(limit)} responseSerializer:nil completion:^(id result, NSError *error) {
        
        [_enrollTable.header endRefreshing];
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
              
                    _enrollArr = result[@"activity_list"];
                    [_enrollTable reloadData];

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
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"三个月内" style:UIBarButtonItemStylePlain target:self action:@selector(choosetime:)];
    [right setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_MIDDLE]} forState:UIControlStateNormal];
    right.width = 100;
    
    self.navigationItem.rightBarButtonItem = right;
    
//    _segment = [[HMSegmentedControl alloc]init];
//    _segment.sectionTitles = @[@"我报名的",@"我参加的"];
//    _segment.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1]};
//    
//    [_segment addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventValueChanged];
//    _segment.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:KNAVICOLOR};
//    _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    [self.view addSubview:_segment];
////    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
////        
////        make.top.leading.trailing.equalTo(self.view);
////        make.height.mas_equalTo(@35);
////    }];
//    _segment.frame = CGRectMake(0, 0, self.view.width, 35);
    
    UILabel *circle = [[UILabel alloc]init];
    circle.frame = CGRectMake(self.view.width*0.94, 10, 10, 10);
    circle.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    circle.textColor = [UIColor whiteColor];
    circle.layer.cornerRadius = 5;
    circle.clipsToBounds = YES;
    circle.textAlignment = NSTextAlignmentCenter;
    circle.backgroundColor = [UIColor redColor];
    [_segment addSubview:circle];
    circle.hidden = YES;
    
    _scroll = [[UIScrollView alloc]init];
    _scroll.delegate = self;
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.pagingEnabled = YES;
    _scroll.bounces = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.scrollEnabled = NO;
    [self.view addSubview:_scroll];
    [_scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
   
    
    UIView *container = [[UIView alloc]init];
    [_scroll addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.trailing.bottom.equalTo(_scroll);
        make.height.equalTo(_scroll);
    }];
    
    UINib *nib = [UINib nibWithNibName:@"MyCollectCell" bundle:nil];
    
    // 报名的
    _enrollTable = [[UITableView alloc]init];
    _enrollTable.backgroundColor = [UIColor clearColor];
    [_enrollTable registerNib:nib forCellReuseIdentifier:@"CELLID"];
    _enrollTable.delegate = self;
    _enrollTable.dataSource = self;
    _enrollTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [container addSubview:_enrollTable];
    [_enrollTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.top.bottom.equalTo(container);
        make.width.equalTo(_scroll);
    }];
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _enrollTable.tableFooterView = foot;
    
    // 参加的
    _attendTable = [[UITableView alloc]init];
    _attendTable.backgroundColor = [UIColor clearColor];
    _attendTable.delegate = self;
    _attendTable.dataSource = self;
    [_attendTable registerNib:nib forCellReuseIdentifier:@"CELLID"];
    [container addSubview:_attendTable];
    [_attendTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(container);
        make.leading.equalTo(_enrollTable.mas_trailing);
        make.width.equalTo(_scroll);
    }];
    _attendTable.tableFooterView = foot;
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(_attendTable);
    }];
    
}

// 刷新
- (void)refreshAction {
    
    [self loadDataWithLimit:_limit];
}

// 选择时间
- (void)choosetime:(UIBarButtonItem *)item {
    
    if ([item.title isEqualToString:@"三个月内"]) {
        
        item.title = @"不限";
        _limit = 0;
        [self loadDataWithLimit:0];
    }
    else {
        item.title = @"三个月内";
        _limit = 1;
        [self loadDataWithLimit:1];
    }
}

/*
//// 分段值改变
//- (void)changeIndex:(HMSegmentedControl *)segment {
//    
//    [_scroll setContentOffset:CGPointMake(segment.selectedSegmentIndex*_scroll.width, 0) animated:YES];
//    _type = segment.selectedSegmentIndex;
//    switch (_type) {
//            // 报名的
//        case 0:
////            if (_enrollArr.count == 0 && _limit != 0) {
//            
//                [self loadDataWithType:0 Limit:_limit];
////            }
//            break;
//            // 参与
//        case 1:
////            if (_attendArr.count == 0 && _limit != 0) {
//            
//                [self loadDataWithType:1 Limit:_limit];
////            }
//            break;
//            
//            // 指派的
//        default:
//            if (_assingArr.count == 0 && _limit != 0) {
//                [self loadDataWithType:2 Limit:_limit];
//            }
//            break;
//    }
//}

// 滑动
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//
//    _segment.selectedSegmentIndex = scrollView.contentOffset.x/_scroll.width;
//}
*/

#pragma mark -UITableView delegate/datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _enrollTable) {
        
        return _enrollArr.count;
    }
    if (tableView == _attendTable) {
        
        return _attendArr.count;
    }
    if (tableView == _assingTable) {
        
        return _assingArr.count;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
    if (tableView == _enrollTable) {
        
        cell.info = _enrollArr[indexPath.row];
//        cell.type = Enroll;
    }
    if (tableView == _attendTable) {
        
        cell.info = _attendArr[indexPath.row];
//        cell.type = Attend;
    }
    cell.isActivity = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hidesBottomBarWhenPushed = YES;
    TaskDetailViewController *detailVC = [[TaskDetailViewController alloc]init];
    detailVC.isActivity = YES;
    detailVC.ID = _enrollArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];

}


@end
