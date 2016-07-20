//
//  NetManager.m
//  MicroNews
//
//  Created by Anker Xiao on 16/7/5.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "NetManager.h"
#import <AFNetworking.h>

@interface NetManager ()

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

@end

@implementation NetManager

+ (instancetype)shareManager
{
    static NetManager *netManager = nil;
    if(netManager == nil)
    {
        netManager = [[NetManager alloc] init];
        netManager.sessionManager = [AFHTTPSessionManager manager];
        netManager.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        netManager.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return netManager;
}

- (void)requestStrUrl:(NSString *)urlStr withSuccessBlock:(SuccessBlock)successB withFailedBlock:(FailedBlock)failedB
{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.sessionManager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successB([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedB(error);
    }];
}

@end
