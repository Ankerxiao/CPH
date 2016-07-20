//
//  SupplierModel.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/14.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface SupplierModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *sales_number;
@property (nonatomic,copy) NSString <Optional> *goods_thumb;
@property (nonatomic,copy) NSString <Optional> *goods_number;
@property (nonatomic,copy) NSString <Optional> *city_name;
@property (nonatomic,copy) NSString <Optional> *province_name;
@property (nonatomic,copy) NSString <Optional> *suppliers_id;
@property (nonatomic,copy) NSString <Optional> *shipping_time;
@property (nonatomic,copy) NSString <Optional> *goods_shipping_fee;
@property (nonatomic,copy) NSString <Optional> *goods_packing;
@property (nonatomic,copy) NSString <Optional> *goods_source;
@property (nonatomic,copy) NSString <Optional> *goods_start_count;
@property (nonatomic,copy) NSString <Optional> *shop_price;
@end
