//
//  TableCell.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/14.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "TableCell.h"
#import <UIImageView+WebCache.h>

@implementation TableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellData:(DataModel *)model
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    self.nameL.text = model.name;
    self.priceL.text = [NSString stringWithFormat:@"最低价：%@",model.shop_price];
    self.priceL.textColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
