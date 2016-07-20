//
//  CVCell.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/13.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "CVCell.h"
#import <UIImageView+WebCache.h>

@implementation CVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellData:(DataModel *)model
{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    self.nameL.text = model.name;
    self.priceL.text = [NSString stringWithFormat:@"最低价：%@",model.shop_price];
    self.priceL.textColor = [UIColor redColor];
}

@end
