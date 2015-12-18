//
//  ViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/19.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "MyTaskViewController.h"
#import "HMSegmentedControl.h"
#import "MyTaskDetailViewController.h"
#import "MyCollectCell.h"
#import "MJRefresh.h"
@interface MyTaskViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
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
    NSInteger _type;
    UILabel *circle;
    BOOL hasNew;
}
@end

@implementation MyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的任务";
    [self loadDataWithType:0 Limit:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAssignATable) name:ASSIGNFINISHED object:nil];
    [self createSubviews];
}

/**
 *  获取数据
 *
 *  @param type 0:我报名的, 1:我参加的, 2:被指派的
 *  @param limit 限制条件：三个月内、无期限
 */
- (void)loadDataWithType:(NSInteger)type Limit:(NSInteger)limit {
    
    [DataService requestURL:@"getNurseTask" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"type":@(type),@"limit":@(limit)} responseSerializer:nil completion:^(id result, NSError *error) {
       
        [_enrollTable.header endRefreshing];
        [_attendTable.header endRefreshing];
        [_assingTable.header endRefreshing];
        if (error == nil) {
//            type 0:我报名的, 1:我参加的, 2:被指派的
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                if (type == 0) {
                    
                    _enrollArr = result[@"task_list"];
                    [_enrollTable reloadData];
                }
                if (type == 1) {
                    
                    _attendArr = result[@"task_list"];
                    [_attendTable reloadData];
                }
                if (type == 2) {
                    
                    _assingArr = result[@"task_list"];
                    [_assingTable reloadData];
                }
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
    
    _segment = [[HMSegmentedControl alloc]init];
    _segment.sectionTitles = @[@"我报名的",@"我参加的",@"被指派的"];
    _segment.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1]};

    [_segment addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventValueChanged];
    _segment.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:KNAVICOLOR};
    _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.view addSubview:_segment];
//    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.top.leading.trailing.equalTo(self.view);
//        make.height.mas_equalTo(@35);
//    }];
    _segment.frame = CGRectMake(0, 0, self.view.width, 35);
    
    circle = [[UILabel alloc]init];
    circle.frame = CGRectMake(self.view.width*0.94, 10, 10, 10);
    circle.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE];
    circle.textColor = [UIColor whiteColor];
    circle.layer.cornerRadius = 5;
    circle.clipsToBounds = YES;
    circle.textAlignment = NSTextAlignmentCenter;
    circle.backgroundColor = [UIColor redColor];
    [_segment addSubview:circle];
    if (_number <= 0) {
        
        circle.hidden = YES;
    }
    
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
       
        make.top.equalTo(_segment.mas_bottom);
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
    _attendTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [container addSubview:_attendTable];
    [_attendTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(container);
        make.leading.equalTo(_enrollTable.mas_trailing);
        make.width.equalTo(_scroll);
    }];
    _attendTable.tableFooterView = foot;
    
    // 指派的
    _assingTable = [[UITableView alloc]init];
    _assingTable.backgroundColor = [UIColor clearColor];
    _assingTable.delegate = self;
    _assingTable.dataSource = self;
    _assingTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [_assingTable registerNib:nib forCellReuseIdentifier:@"CELLID"];
    [container addSubview:_assingTable];
    [_assingTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(container);
        make.leading.equalTo(_attendTable.mas_trailing);
        make.width.equalTo(_scroll);
        make.trailing.equalTo(container);
    }];
    
    _assingTable.tableFooterView = foot;
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(_assingTable);
    }];

}

- (void)refreshAction {
    
    [self loadDataWithType:_type Limit:_limit];
}

// 选择时间
- (void)choosetime:(UIBarButtonItem *)item {
 
    if ([item.title isEqualToString:@"三个月内"]) {
        
        item.title = @"不限";
        _limit = 0;
        [self loadDataWithType:_type Limit:0];
    }
    else {
        item.title = @"三个月内";
        _limit = 1;
        [self loadDataWithType:_type Limit:1];
    }
}

// 分段值改变
- (void)changeIndex:(HMSegmentedControl *)segment {
 
    
    [_scroll setContentOffset:CGPointMake(segment.selectedSegmentIndex*_scroll.width, 0) animated:YES];
    _type = segment.selectedSegmentIndex;
    switch (_type) {
            // 报名的
        case 0:
//            if (_enrollArr.count == 0 && _limit != 0) {
            
                [self loadDataWithType:0 Limit:_limit];
//            }
            break;
            // 参与
        case 1:
//            if (_attendArr.count == 0 && _limit != 0) {
            
                [self loadDataWithType:1 Limit:_limit];
//            }
            break;
            
            // 指派的
        default:
//            if (_assingArr.count == 0 && _limit != 0) {
                [self loadDataWithType:2 Limit:_limit];
//            }
            break;
    }
}

// 滑动
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//    _segment.selectedSegmentIndex = scrollView.contentOffset.x/_scroll.width;
//}


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
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];

    if (tableView == _enrollTable) {
        
        cell.info = _enrollArr[indexPath.row];
        cell.type = Enroll;
    }
    if (tableView == _attendTable) {
        
        cell.info = _attendArr[indexPath.row];
        cell.type = Attend;
    }
    if (tableView == _assingTable) {
        
        cell.info = _assingArr[indexPath.row];
        cell.type = assigned;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 已关闭
    switch (_segment.selectedSegmentIndex) {
        case 0:
            
            if ([_enrollArr[indexPath.row][@"is_closed"] isEqualToString:@"1"]) {
                
                return;
            }
            break;
        case 1:
            if ([_attendArr[indexPath.row][@"is_closed"] isEqualToString:@"1"]) {
                
                return;
            }
            break;
        default:
            if ([_assingArr[indexPath.row][@"is_closed"] isEqualToString:@"1"]) {
                
                return;
            }
            break;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    MyTaskDetailViewController *detailVC = [[MyTaskDetailViewController alloc]init];

    if (tableView == _enrollTable) {
        
        detailVC.taskType = MyEnroll;
        detailVC.ID = _enrollArr[indexPath.row][@"id"];
    }
    if (tableView == _attendTable) {
        
        detailVC.taskType = MyAttend;
        detailVC.ID = _attendArr[indexPath.row][@"id"];
    }
    if(tableView == _assingTable) {
        detailVC.taskType = Myassigned;
        detailVC.ID = _assingArr[indexPath.row][@"id"];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

// 刷新被指派列表
- (void)reloadAssignATable {
    
    [DataService requestURL:@"getNurseTask" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"type":@(2),@"limit":@(_limit)} responseSerializer:nil completion:^(id result, NSError *error) {
 
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                _assingArr = result[@"task_list"];
                [_assingTable reloadData];
                for (NSDictionary *dic in _assingArr) {
                    
                    if ([dic[@"verify_status"] isEqualToString:@"0"]) {
                        
                        hasNew = YES;
                    }
                }
                if (hasNew) {
                    
                    circle.hidden = NO;
                }
                else {
                    circle.hidden = YES;
                }
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
@end
