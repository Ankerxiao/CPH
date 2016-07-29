//
//  GoodsListCell.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/25.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "GoodsListCell.h"
#import <UIImageView+WebCache.h>

@interface GoodsListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;

@end

@implementation GoodsListCell

- (void)updateGoodsListDataInCell:(GoodDetailModel *)model andPurchaseNum:(NSInteger)number;
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    self.nameL.text = model.goods_short_name;
    self.priceL.text = model.shop_price;
    self.numberL.text = [NSString stringWithFormat:@"X%ld",number];
}

- (void)updateDataWithCart:(CartModel *)model
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    self.nameL.text = model.goods_name;
    self.priceL.text = model.goods_price;
    self.numberL.text = [NSString stringWithFormat:@"X%@",model.goods_number];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
