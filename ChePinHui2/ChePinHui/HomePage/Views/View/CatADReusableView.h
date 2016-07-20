//
//  CatADReusableView.h
//  CPH
//
//  Created by keane on 16/7/14.
//  Copyright © 2016年 keane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdData.h"

@interface CatADReusableView : UICollectionReusableView
@property (nonatomic,strong)UIImageView *imageV;

-(void)updateData:(AdData*)data;
@end
