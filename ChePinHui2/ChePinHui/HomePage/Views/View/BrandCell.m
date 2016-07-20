//
//  BrandCell.m
//  CPH
//
//  Created by keane on 16/7/14.
//  Copyright © 2016年 keane. All rights reserved.
//

#import "BrandCell.h"

@implementation BrandCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updateCellData:(BrandData*)data
{
    [_brandImageV sd_setImageWithURL:[NSURL URLWithString:data.brand_logo]];
}
@end
