//
//  ServerHeader.h
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/18.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#ifndef _________ServerHeader_h
#define _________ServerHeader_h

#define FONT_SIZE_LARGE 16
#define FONT_SIZE_MIDDLE 14
#define FONT_SIZE_SMALL 12

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

#define iOS8            [[UIDevice currentDevice].systemVersion floatValue] >= 8.0
#define iOS7            [[UIDevice currentDevice].systemVersion floatValue] >= 7.0


// 导航栏颜色
#define KNAVICOLOR [UIColor colorWithRed:0.294f green:0.475f blue:0.925f alpha:1.00f]

// 高德key
#define GAODEKEY @"8ab28d36ac459d8d3ef1f04213f54f91"

// 基本个人信息
#define HKHL_MEMBERID @"HKHL_MEMBERID"
#define HKHL_MEMBERPHONE @"HKHL_MEMBERPHONE"
#define HKHL_USERNAME @"HKHL_USERNAME"
#define HKHL_AVATAR  @"HKHL_AVATAR"
#define HKHL_TITLE  @"HKHL_TITLE"

// 用户名和密码
#define REMEMBERPHONR @"REMEMBERPHONR"
#define REMEMBERPWD @"REMEMBERPWD"

// 通知
#define LOGIN_SUCCESS @"LOGIN_SUCCESS_NOTIFY"
#define MODIFY_HOSPITAL_SUCCESS @"MODIFYHOSPITAL_NOTIFY"
#define ASSIGNFINISHED @"ASSIGNFINISHED_NOTIFY"
#define READNEWSNOFITY @"READNEWSNOFITY"

// 域名
#define BASEURL  @"http://hk.zgcainiao.cn"
#endif
