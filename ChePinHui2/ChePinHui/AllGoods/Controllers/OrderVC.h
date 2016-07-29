//
//  OrderVC.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/21.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailModel.h"

@interface OrderVC : UIViewController
@property (nonatomic,strong) GoodDetailModel *gdModel;
//@property (nonatomic,copy) NSString *goodsID;

@property (nonatomic,copy) NSString *purchaseNum;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *goods_Name;

@property (nonatomic,copy) NSArray *dataArr;
@property (nonatomic,copy) NSString *sumPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceSumL;
@end
