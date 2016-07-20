//
//  CVCell.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/13.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface CVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@property (nonatomic,strong) DataModel *model;
- (void)updateCellData:(DataModel *)model;

@end
