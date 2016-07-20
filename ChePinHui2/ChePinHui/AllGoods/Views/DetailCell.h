//
//  DetailCell.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/14.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupplierModel.h"

@protocol DetailCellDelegate <NSObject>

//多态
- (void)presentVC:(UITableViewCell *)dcell andVC:(UIViewController *)vc;

@end

@interface DetailCell : UITableViewCell

@property (nonatomic,strong) SupplierModel *model;
@property (nonatomic,weak) id <DetailCellDelegate> delegate;
- (void)updateCellData:(SupplierModel *)model;
@end

