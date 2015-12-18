//
//  DataService.m
//  XSWeibo
//
//  Created by student on 15-4-13.
//  Copyright (c) 2015年 student. All rights reserved.
//

#import "DataService.h"

@implementation DataService
+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlString
                            httpMethod:(NSString *)method
                               timeout:(NSTimeInterval)time
                                params:(NSDictionary *)params
                    responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                            completion:(void(^)(id result,NSError *error))block {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = time;
    method = [method uppercaseString];
    urlString = [NSString stringWithFormat:@"http://hk.zgcainiao.cn/index.php/admin/api/%@",urlString];
    if (responseSerializer == nil) {
        
        responseSerializer = [AFJSONResponseSerializer serializer];
    }
    manager.responseSerializer = responseSerializer;
    AFHTTPRequestOperation *operation = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // GET请求
    if ([method isEqualToString:@"GET"]) {
        
        
        operation = [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 回调block
            if (block != nil) {
                
                block(responseObject,nil);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 错误提示
            if (error.code == -1009) {
                
                error = [NSError errorWithDomain:@"无网络" code:-1009 userInfo:nil];
            }
            else if (error.code == -1001) {
                error = [NSError errorWithDomain:@"网络有点慢" code:-1001 userInfo:nil];
            }
            else if (error.code == 3840) {
                error = [NSError errorWithDomain:@"数据异常" code:3840 userInfo:nil];
            }
            if (block != nil) {
                
                block(nil,error);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
    // POST请求
    else if ([method isEqualToString:@"POST"]){
        
               // 无图片，音频、视频
            operation = [manager POST: urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                // 回调block
                if (block != nil) {
                    
                    block(responseObject,nil);
                }
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                if (error.code == -1009) {
                    
                    error = [NSError errorWithDomain:@"无网络" code:-1009 userInfo:nil];
                }
                else if (error.code == -1004) {
                    error = [NSError errorWithDomain:@"连接服务器失败" code:-1001 userInfo:nil];
                }
                else if (error.code == -1001) {
                    error = [NSError errorWithDomain:@"连接超时" code:-1001 userInfo:nil];
                }
                else if (error.code == 3840) {
                    error = [NSError errorWithDomain:@"数据异常" code:3840 userInfo:nil];
                }
                if (block != nil) {
                    
                    block(nil,error);
                }
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
        }
        
    return operation;
    

}


/**
 *  方法描述
 *
 *  @param urlString          访问的url
 *  @param method             访问方式
 *  @param time               超时时间
 *  @param params             参数
 *  @param data               文件
 *  @param responseSerializer 返回值参数
 *  @param block              返回值后回调
 *
 *  @return return value description
 */
+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlString
                               timeout:(NSTimeInterval)time
                                params:(NSDictionary *)params
                              fileData:(NSData *)data
                    responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                            completion:(void(^)(id result,NSError *error))block {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    urlString = [NSString stringWithFormat:@"http://hk.zgcainiao.cn/index.php/admin/api/%@",urlString];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = time;
    if (responseSerializer == nil) {
        
        responseSerializer = [AFJSONResponseSerializer serializer];
    }
    manager.responseSerializer = responseSerializer;
    AFHTTPRequestOperation *operation = [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data
                                            name:@"avatar"
                                        fileName:@"rich.jpg"
                                        mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 回调block
        if (block != nil) {
            
            block(responseObject,nil);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        if (error.code == -1009) {
//            
//            error = [NSError errorWithDomain:@"网络连接出现问题" code:-1009 userInfo:nil];
//        }
//        else if (error.code == -1001) {
//            error = [NSError errorWithDomain:@"连接超时" code:-1001 userInfo:nil];
//        }
//        else if (error.code == 3840) {
//            error = [NSError errorWithDomain:@"数据异常" code:3840 userInfo:nil];
//        }
        block(nil,error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];

    return operation;
}

+ (void)checkNetWork:(void (^)(AFNetworkReachabilityStatus))block{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        block(status);
    }];
}
@end
