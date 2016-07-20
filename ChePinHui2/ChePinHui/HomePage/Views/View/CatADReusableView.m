//
//  CatADReusableView.m
//  CPH
//
//  Created by keane on 16/7/14.
//  Copyright © 2016年 keane. All rights reserved.
//

#import "CatADReusableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation CatADReusableView

-(UIImageView*)imageV
{
    if(_imageV == nil){
        _imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageV];
    }
    return _imageV;
}

-(void)updateData:(AdData*)data
{
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meichemeipin.com/mobile/data/afficheimg/%@",data.ad_code]]];
}
@end
