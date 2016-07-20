//
//  GoodsData.h
//  CPH
//
//  Created by keane on 16/7/14.
//  Copyright © 2016年 keane. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GoodsData : JSONModel
@property (nonatomic,copy)NSString* goods_id;
@property (nonatomic,copy)NSString* name;
@property (nonatomic,copy)NSString* shop_price;
@property (nonatomic,copy)NSString* market_price;
@property (nonatomic,copy)NSString* promote_price;
@property (nonatomic,copy)NSString* goods_thumb;
@property (nonatomic,copy)NSString* goods_img;
@property (nonatomic,copy)NSString* goods_number;
@property (nonatomic,copy)NSString* child_number;
@end
