//
//  DataModel.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

+ (JSONKeyMapper *)keyMapper
{
    JSONKeyMapper *keymapper = [[JSONKeyMapper alloc] initWithDictionary:@{}];
    return keymapper;
}

@end
