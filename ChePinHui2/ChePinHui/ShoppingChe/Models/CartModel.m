//
//  CartModel.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/19.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel
+ (JSONKeyMapper *)keyMapper
{
    JSONKeyMapper *keymapper = [[JSONKeyMapper alloc] initWithDictionary:@{}];
    return keymapper;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    if(self = [super initWithDictionary:dict error:err])
    {
        _isSelected = @"0";
    }
    return self;
}

@end
