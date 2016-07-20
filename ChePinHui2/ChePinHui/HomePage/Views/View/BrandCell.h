//
//  BrandCell.h
//  CPH
//
//  Created by keane on 16/7/14.
//  Copyright © 2016年 keane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandData.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BrandCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *brandImageV;


-(void)updateCellData:(BrandData*)data;
@end
