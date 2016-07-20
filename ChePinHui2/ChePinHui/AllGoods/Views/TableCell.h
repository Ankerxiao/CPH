//
//  TableCell.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/14.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface TableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

- (void)updateCellData:(DataModel *)model;

@end
