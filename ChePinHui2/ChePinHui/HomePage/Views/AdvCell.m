//
//  AdvCell.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "AdvCell.h"
#import <UIImageView+WebCache.h>

@interface AdvCell ()




@end

@implementation AdvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(DataModel *)model
{
    _model = model;
    
}

//- (UIScrollView *)createAdvScrollView
//{
//    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//    NSInteger count = self.advDataArray.count;
//    for(int i=0;i<count;i++)
//    {
//        DataModel *model = [[DataModel alloc] init];
//        model = self.advDataArray[i];
//        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//        [imageV sd_setImageWithURL:[NSURL URLWithString:model.ad_link]];
//        [sv addSubview:imageV];
//    }
//    sv.pagingEnabled = YES;
//    sv.showsHorizontalScrollIndicator = YES;
//    sv.contentSize = CGSizeMake(count*SCREEN_WIDTH, 0);
//    return sv;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
