//
//  UIView+UIViewController.m
//  XSWeibo
//
//  Created by student on 15-4-14.
//  Copyright (c) 2015年 student. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

- (UIViewController *)viewController {
    
    UIResponder *responder = self.nextResponder;
    while (responder) {
        
        if ([responder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    }
    return nil;
}
@end
