//
//  AddCertificateViewController.h
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/24.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

@protocol AddCertificateDelegate <NSObject>

@optional

- (void)AddCertificateSuccess:(NSDictionary *)certificate;

@end
#import "BaseViewController.h"

@interface AddCertificateViewController : BaseViewController
@property (nonatomic,assign)id<AddCertificateDelegate> delegate;
@end
