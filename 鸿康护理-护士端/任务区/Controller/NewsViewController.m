//
//  NewsViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/12/2.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "NewsViewController.h"
#import "NoticificationCell.h"
#import "MJRefresh.h"

@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSInteger p;
    NSMutableArray *news;
    NSInteger selectedRow;
}
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"我的消息";
    p = 1;
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"NoticificationCell" bundle:nil] forCellReuseIdentifier:@"CellID"];
    [self.view addSubview:_tableView];
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = foot;
    _tableView.hidden = YES;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    [self loadDataWithPage:p];
}

// 获取消息
- (void)loadDataWithPage:(NSInteger)page {
    
//    输入：{“role_id”:”消息接收人角色 1:发布者 2:护士”, “user_id”：“消息接收人ID 既护士/发布者ID”， ”p”:”分页参数”}
    
    [DataService requestURL:@"getMassage" httpMethod:@"post" timeout:10 params:@{@"role_id":@2,@"user_id":[Utility getID],@"p":@(page)} responseSerializer:nil completion:^(id result, NSError *error) {
       
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
        if (error == nil) {
            
            if (page == 1) {
                
                news = [NSMutableArray array];
                [_tableView.footer resetNoMoreData];
            }
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                _tableView.hidden = NO;
                
                [news addObjectsFromArray:result[@"message_list"]];
                if (((NSArray *)result[@"message_list"]).count < 10) {
                    
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
                
                if (p > 1) {
                    
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

// 加载更多
- (void)loadMore {
    
    p++;
    [self loadDataWithPage:p];
}

// 刷新
- (void)refreshAction {

    p = 1;
    [self loadDataWithPage:p];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return news.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == selectedRow) {
        
        NSString *content = [news[indexPath.row] objectForKey:@"content"];
        CGFloat labelWidth = self.view.width-16;
        
        NSDictionary *attrubutes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:15]
                                     };
        
        //计算文本的高度
        CGRect bounds = [content boundingRectWithSize:CGSizeMake(labelWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrubutes context:nil];
        
        return bounds.size.height+35 > 85 ? bounds.size.height:85;
    }
    
    return 85;


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoticificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.infoDic = news[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedRow = indexPath.row;
    NoticificationCell *cell = (NoticificationCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.unreadImg.hidden = YES;
    [tableView reloadData];

}

- (void)backAction {
    
    [super backAction];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:READNEWSNOFITY object:nil];
}
@end

