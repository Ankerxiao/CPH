//
//  GoodDetailModel.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/18.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodsPicModel.h"

@interface GoodDetailModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *goods_id;
@property (nonatomic,copy) NSString <Optional> *goods_img;
@property (nonatomic,copy) NSArray <Optional> *goods_pics;
@property (nonatomic,copy) NSString <Optional> *shop_price;
@property (nonatomic,copy) NSString <Optional> *goods_short_name;
@property (nonatomic,copy) NSString <Optional> *goods_number;
@property (nonatomic,copy) NSString <Optional> *goods_packing;
@property (nonatomic,copy) NSString <Optional> *goods_brief;
@end
