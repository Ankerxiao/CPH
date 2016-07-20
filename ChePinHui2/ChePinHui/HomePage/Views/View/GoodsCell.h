//
//  GoodsCell.h
//  CPH
//
//  Created by keane on 16/7/14.
//  Copyright © 2016年 keane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsData.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GoodsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgV;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

-(void)updateCellData:(GoodsData*)data;
@end
