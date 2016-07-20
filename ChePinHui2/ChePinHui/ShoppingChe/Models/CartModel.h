//
//  CartModel.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/19.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CartModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *goods_id;
@property (nonatomic,copy) NSString <Optional> *goods_thumb;
@property (nonatomic,copy) NSString <Optional> *goods_name;
@property (nonatomic,copy) NSString <Optional> *goods_number;
@property (nonatomic,copy) NSString <Optional> *goods_price;
@property (nonatomic,assign) NSString <Optional> *isSelected;
@end
