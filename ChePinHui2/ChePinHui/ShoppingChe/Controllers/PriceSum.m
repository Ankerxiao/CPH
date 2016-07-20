//
//  PriceSum.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/19.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "PriceSum.h"

@implementation PriceSum

+ (id)sharedPriceSum
{
    static PriceSum *priceSum = nil;
    @synchronized (self)
    {
        if(nil == priceSum)
        {
            priceSum = [[PriceSum alloc] init];
        }
    }
    return priceSum;
}

- (void)calculatePrice
{
    
}

@end
