//
//  GoodsListCell.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/25.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailModel.h"
#import "CartModel.h"

@interface GoodsListCell : UITableViewCell
- (void)updateGoodsListDataInCell:(GoodDetailModel *)model andPurchaseNum:(NSInteger)number;
- (void)updateDataWithCart:(CartModel *)model;
@end
