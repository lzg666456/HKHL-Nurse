//
//  UserInfoViewController.h
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/19.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//
//确定：性别、执业地点、文化水平、就职医院、职称是弹框选择的，有接口提供数据
#import "BaseViewController.h"

@interface UserInfoViewController : BaseViewController
@property (nonatomic,strong)NSArray *eduArr;             // 文化水平数组
@property (nonatomic,strong)NSArray *addressArr;         // 执业地点
@property (nonatomic,strong)NSArray *hospitalArr;        // 就职医院
@property (nonatomic,strong)NSArray *titleArr;           // 职称数组
@property (nonatomic,strong)NSMutableDictionary *postParams;    // 上传参数
@end
