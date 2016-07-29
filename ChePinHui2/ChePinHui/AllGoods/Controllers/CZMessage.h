//
//  CZMessage.h
//  001QQ聊天界面
//
//  Created by apple on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CZMessageTypeMe = 0,    // 表示自己
    CZMessageTypeOther = 1  // 表示对方
} CZMessageType;


@interface CZMessage : NSObject

// 消息正文
@property (nonatomic, copy) NSString *text;

// 消息发送时间
@property (nonatomic, copy) NSString *time;

// 消息的类型（表示是对方发送的消息还是自己发送的消息）
@property (nonatomic, assign) CZMessageType type;

// 用来记录是否需要显示"时间Label"
@property (nonatomic, assign) BOOL hideTime;



- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end







