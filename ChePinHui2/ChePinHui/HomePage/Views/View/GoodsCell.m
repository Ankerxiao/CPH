//
//  GoodsCell.m
//  CPH
//
//  Created by keane on 16/7/14.
//  Copyright © 2016年 keane. All rights reserved.
//

#import "GoodsCell.h"

@implementation GoodsCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updateCellData:(GoodsData*)data
{
    [_goodsImgV sd_setImageWithURL:[NSURL URLWithString:data.goods_thumb]];
    [_goodsName setText:data.name];
    [_goodsPrice setText:data.shop_price];
}

@end
