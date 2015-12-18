//
//  MainTabbarController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/18.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "MainTabbarController.h"
#import "BaseNaviController.h"
#import "ActivityViewController.h"
#import "TaskViewController.h"
#import "NoticeViewController.h"
#import "UserHomeViewController.h"
#import "LoginViewController.h"
#import "BarItem.h"
@interface MainTabbarController ()
{
        BarItem *selectedButton;
}
@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createChildControllers];
    [self createItems];
}

- (void)createChildControllers {
    
    NSArray *VCs = @[[[TaskViewController alloc]init],[[ActivityViewController alloc]init],[[NoticeViewController alloc]init],[[UserHomeViewController alloc]init]];
    
    for (int i = 0; i < 4; i++) {
    
        if (i == 3 && [[NSUserDefaults standardUserDefaults] objectForKey:HKHL_MEMBERID]==nil) {
            
          BaseNaviController *navi = [[BaseNaviController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
            [self addChildViewController:navi];
        }
        else {
        BaseNaviController *navi = [[BaseNaviController alloc]initWithRootViewController:VCs[i]];
        [self addChildViewController:navi];
        }
    }
}

- (void)createItems {
    
    NSArray *titles = @[@"任务区",@"活动区",@"医院公告",@"个人中心"];
    NSArray *imgNames = @[@"任务区_xxhdpi",@"活动区_xxhdpi",@"医院公告_xxhdpi",@"个人中心_xxhdpi"];
    NSArray *selectedImgNames = @[@"任务区选中_xxhdpi",@"活动区选中_xxhdpi",@"医院公告选中_xxhdpi",@"个人中心选中_xxhdpi"];
    CGFloat width = kScreenWidth /4.0;
    for (int i = 0; i < 4; i++) {
        
        BarItem *item = [[BarItem alloc]initWithFrame:CGRectMake(i*width, 3, width, self.tabBar.height-3) title:titles[i] image:imgNames[i] titleColor:[UIColor blackColor]];
        item.selectedImg = selectedImgNames[i];
        item.selectedColor = [UIColor redColor];
        [item addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = 10+i;
        if (i == 0) {
            
            selectedButton = item;
            item.isSelected = YES;
        }
        [self.tabBar addSubview:item];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    for (UIView *subViews in self.tabBar.subviews) {
        
        if ([subViews isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            [subViews removeFromSuperview];
        }
    }
}
// tabbar按钮切换
- (void)changeIndex:(BarItem *)button {
    
    self.selectedIndex = button.tag-10;
    selectedButton.isSelected = NO;
    button.isSelected = YES;
    selectedButton = button;
}


// 复写tab切换
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    BarItem *button = (BarItem *)[self.tabBar viewWithTag:selectedIndex+10];
    button.isSelected = YES;
    selectedButton.isSelected = NO;
    button.isSelected = YES;
    selectedButton = button;
    
}


@end
