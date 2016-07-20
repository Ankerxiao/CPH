//
//  DataModel.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface DataModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *ad_link; //图片地址
@property (nonatomic,copy) NSString <Optional> *ad_name; //广告名字
@property (nonatomic,copy) NSString <Optional> *ad_code;

@property (nonatomic,copy) NSString <Optional> *goods_thumb;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *shop_price;

@property (nonatomic,copy) NSString <Optional> *brand_name;
@property (nonatomic,copy) NSString <Optional> *brand_logo;

@property (nonatomic,copy) NSString <Optional> *goods_id;

@end
