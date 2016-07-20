//
//  NetManager.h
//  MicroNews
//
//  Created by Anker Xiao on 16/7/5.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock) (id data);
typedef void (^FailedBlock) (NSError *error);

@interface NetManager : NSObject

+ (instancetype)shareManager;

- (void)requestStrUrl:(NSString *)urlStr withSuccessBlock:(SuccessBlock)successB withFailedBlock:(FailedBlock)failedB;

@end
