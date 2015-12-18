//
//  TaskViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/18.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "TaskViewController.h"
#import "HMSegmentedControl.h"
#import "TaskDetailViewController.h"
#import "ADDetailViewController.h"
#import "NewsViewController.h"
#import "SDCycleScrollView.h"
#import "TaskCell.h"
#import "MJRefresh.h"
@interface TaskViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
    HMSegmentedControl *_segment;
    NSArray *filterArr;
    UITableView *_tableView;
    UITableView *_filterTable;
    UILabel *titleLabel;
    UIImageView *down;
    UIScrollView *scroll;
    UIControl *filterBtn;
    NSInteger p;
    NSInteger _order;   //排序方式
    NSInteger _where;   //筛选条件
    NSMutableArray *_taskList;
    NSMutableArray *adimgs;
    SDCycleScrollView *scrollPhoto;
    UIImageView *redPoint;
}
@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    p = 1;
    self.title = @"鸿康护理";
    self.backBtn.hidden = YES;
    filterArr = @[@"所有",@"进行中",@"已结束"];
    [self getAdvertisement];
    [self loadDataWithPage:0 Order:0 Where:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearUnread) name:READNEWSNOFITY object:nil];
    if ([Utility getID]) {
        
        [self loadUnreadNews];
    }
    [self createSubviews];
}

#pragma mark -  数据获取
/**
 *  获取任务
 *
 *  @param page  页码
 *  @param order 排序方式
 *  @param where 筛选条件
 */
- (void)loadDataWithPage:(NSInteger)page Order:(NSInteger)order Where:(NSInteger)where{
    
//    输入：{“order”:”0/1”, “where”：“0/1/2”, ”p”:”分页参数”}
//    说明：order：排序依据 0:按任务发布时间降序 1:按任务报名人气降序，
//    where：筛选条件 0:所有 1:任务进行中 2:任务已结束
//p:每页20条，不传默认查询第一页，其他例如：p=2查询第二页
    [DataService requestURL:@"getTaskList" httpMethod:@"post" timeout:10 params:@{@"order":@(order),@"p":@(page),@"where":@(where)} responseSerializer:nil completion:^(id result, NSError *error) {
       
        [scroll.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (p == 1) {
            
            _taskList = [NSMutableArray array];
        }
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                [_taskList addObjectsFromArray:result[@"task_list"]];
                _tableView.hidden = NO;
                if (_taskList.count < 10) {
                    
                    [_tableView.footer noticeNoMoreData];
                }
                else {
                    _tableView.footer.hidden = NO;
                }
            }
            else {
                
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                _tableView.footer.hidden = YES;

            }
            [_tableView reloadData];
        }
        else {
            if (error.code == 3840) {
                
                if (page > 1) {
                    
                    [SVProgressHUD showErrorWithStatus:@"无更多数据"];
                    [_tableView.footer noticeNoMoreData];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    
                }
                return ;
            }
            [SVProgressHUD showErrorWithStatus:error.domain];
            
        }
    }];
}

// 获取是否有未读消息
- (void)loadUnreadNews {

    [DataService requestURL:@"hasNewMassage" httpMethod:@"post" timeout:10 params:@{@"role_id":@2,@"user_id":[Utility getID]} responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                if ([result[@"number"] integerValue] > 0) {
                    
                    redPoint.hidden = NO;
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

// 获取广告
- (void)getAdvertisement {
    
    [DataService requestURL:@"getAdvertisement" httpMethod:@"post" timeout:10 params:nil responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
             
                _ADList = result[@"list"];
                adimgs = [NSMutableArray array];
                for (NSDictionary *dic in _ADList) {
                    
                    [adimgs addObject:dic[@"picture"]];
                }
                scrollPhoto = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, scroll.height*0.3)];
                scrollPhoto.delegate = self;
                scrollPhoto.placeholderImage = [UIImage imageNamed:@"主图_xxhdpi"];
                scrollPhoto.imageURLStringsGroup = adimgs;
                [scroll addSubview:scrollPhoto];
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

// 清除未读消息标记
- (void)clearUnread {
    
    redPoint.hidden = YES;
}
#pragma mark - 创建子视图
- (void)createSubviews {
    
    UIButton *newsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsBtn setTitle:@"消息" forState:UIControlStateNormal];
    newsBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_LARGE];
    [newsBtn addTarget:self action:@selector(readNews) forControlEvents:UIControlEventTouchUpInside];
    newsBtn.frame = CGRectMake(0, 0, 50, 30);
    
    redPoint = [[UIImageView alloc]initWithFrame:CGRectMake(40,5, 10, 10)];
    redPoint.image = [UIImage imageNamed:@"新任务_xxhdpi"];
    [newsBtn addSubview:redPoint];
    redPoint.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:newsBtn];
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    scroll.height = self.view.height-64-49;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.delegate = self;
    scroll.backgroundColor = [UIColor clearColor];
    scroll.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.view addSubview:scroll];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, scroll.height*0.3)];
    imgView.image = [UIImage imageNamed:@"主图_xxhdpi"];
    [scroll addSubview:imgView];

    _segment = [[HMSegmentedControl alloc]initWithFrame:CGRectMake(0, scroll.height*0.3+1, self.view.width*0.7, 35)];
    _segment.sectionTitles = @[@"按时间      ",@"按人气         "];
    _segment.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1]};
    [_segment addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventValueChanged];
    _segment.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:KNAVICOLOR};
    _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [scroll addSubview:_segment];
    

    filterBtn = [[UIControl alloc]init];
    filterBtn.frame = CGRectMake(_segment.right-1, _segment.y, self.view.width*0.3, 35);
    filterBtn.backgroundColor = [UIColor whiteColor];
    [filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    filterBtn.selected = NO;
    [scroll addSubview:filterBtn];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, filterBtn.width*0.6, filterBtn.height)];
    titleLabel.text = @"所有";
    titleLabel.tag = 1;
    titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1];
    titleLabel.textAlignment = NSTextAlignmentRight;
    [filterBtn addSubview:titleLabel];
    
    down = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.right+3, 10, 12, filterBtn.height-20)];
    down.tag = 2;
    down.image = [UIImage imageNamed:@"向下灰色_xxhdpi"];
    [filterBtn addSubview:down];

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _segment.bottom+1, self.view.width,scroll.height-35)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = foot;
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

    [_tableView registerNib:[UINib nibWithNibName:@"TaskCell" bundle:nil] forCellReuseIdentifier:@"CellID"];
    _tableView.hidden = YES;
    [scroll addSubview:_tableView];
    scroll.contentSize = CGSizeMake(scroll.width, imgView.height+_tableView.height-15);

}

// 读取消息
- (void)readNews {
    
    if (![Utility getID]) {
        
        [SVProgressHUD showErrorWithStatus:@"请先登录!"];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    [self.navigationController pushViewController:newsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

// 刷新
- (void)refreshAction {
    
    p = 1;
    [self loadDataWithPage:p Order:_order Where:_where];
}

// 加载更多
- (void)loadMore {
    
    p++;
    [self loadDataWithPage:p Order:_order Where:_where];
}

// 筛选（所有/进行中/已结束）
- (void)filterAction:(UIControl *)item {
    
    item.selected = !item.selected;
    
    if (item.selected) {
        
        down.image = [UIImage imageNamed:@"向下蓝色_xxhdpi"];
        titleLabel.textColor = KNAVICOLOR;
        if (_filterTable == nil) {
            
            _filterTable = [[UITableView alloc]init];
            _filterTable.delegate = self;
            _filterTable.dataSource = self;
            _filterTable.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _filterTable.layer.borderWidth = 1;
            [_filterTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"filterCell"];
        }
        _filterTable.frame = CGRectMake(item.x, item.bottom, item.width, 0);
        [scroll addSubview:_filterTable];
        [UIView animateWithDuration:.3 animations:^{
           
            _filterTable.height = 105;
        }];
    }
    else {
     
        [UIView animateWithDuration:.3 animations:^{
            
            _filterTable.height = 0;
            
        } completion:^(BOOL finished) {
            
            [_filterTable removeFromSuperview];
        }];
        down.image = [UIImage imageNamed:@"向下灰色_xxhdpi"];
        titleLabel.textColor = [UIColor blackColor];
    }
}

// 分段控制器值改变
- (void)changeIndex:(HMSegmentedControl *)segment {
    
    _order = segment.selectedSegmentIndex;
    p = 1;
    [self loadDataWithPage:p Order:_order Where:_where];
    
    filterBtn.selected = NO;
    down.image = [UIImage imageNamed:@"向下灰色_xxhdpi"];
    titleLabel.textColor = [UIColor blackColor];
    [UIView animateWithDuration:.3 animations:^{
        
        _filterTable.height = 0;
        
    } completion:^(BOOL finished) {
        [_filterTable removeFromSuperview];
        
    }];

}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _filterTable) {
        
        return filterArr.count;
    }
    return _taskList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _filterTable) {
        
        return 35;
    }
    return 70.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 筛选列表
    if (tableView == _filterTable) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterCell" forIndexPath:indexPath];
        cell.textLabel.text = filterArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE+1];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.dic = _taskList[indexPath.row];
    if (_segment.selectedSegmentIndex == 1) {
        
        cell.isPopular = YES;
    }
    else {
        cell.isPopular = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 筛选列表
    if (tableView == _filterTable) {
        filterBtn.selected = NO;
        down.image = [UIImage imageNamed:@"向下灰色_xxhdpi"];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = filterArr[indexPath.row];
        [UIView animateWithDuration:.3 animations:^{
           
            tableView.height = 0;
            
        } completion:^(BOOL finished) {
            [tableView removeFromSuperview];
            
        }];
        if (indexPath.row != _where) {
            
            _where = indexPath.row;
            p = 1;
            [self loadDataWithPage:p Order:_order Where:_where];
        }
    }
    else {
        
        if ([Utility getID] == nil) {
            
            [SVProgressHUD showErrorWithStatus:@"请先登录"];
            [self performSelector:@selector(goLogin) withObject:nil afterDelay:1];
            return;
        }

        self.hidesBottomBarWhenPushed = YES;
        TaskDetailViewController *detailVC = [[TaskDetailViewController alloc]init];
        detailVC.ID = _taskList[indexPath.row][@"id"];
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}

// 前往登录
- (void)goLogin {
    self.tabBarController.selectedIndex = 3;
}

// 轮播图点击
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    self.hidesBottomBarWhenPushed = YES;
    ADDetailViewController *detailVC = [[ADDetailViewController alloc]init];
    detailVC.ID = self.ADList[index][@"id"];
    detailVC.title = self.ADList[index][@"subject"];
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _filterTable) {
        
        return;
    }
    filterBtn.selected = NO;
    down.image = [UIImage imageNamed:@"向下灰色_xxhdpi"];
    titleLabel.textColor = [UIColor blackColor];
    [UIView animateWithDuration:.3 animations:^{
        
        _filterTable.height = 0;
        
    } completion:^(BOOL finished) {
        [_filterTable removeFromSuperview];
        
    }];

}
@end
