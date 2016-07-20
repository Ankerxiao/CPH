//
//  CartCell.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/19.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

@protocol CartCellDelegate <NSObject>

@optional
- (void)updatePrice:(CartModel *)price;

@end

@interface CartCell : UITableViewCell
@property (nonatomic,weak) id <CartCellDelegate> delegate;
@property (nonatomic,strong) CartModel *cartModel;
@property (nonatomic,assign) NSInteger purchaseNum;
- (void)updateCellData:(CartModel *)model;
@end
