//
//  DetailCell.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/14.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "DetailCell.h"
#import <UIImageView+WebCache.h>
#import "GoodsDetailVC.h"

@interface DetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *saleNumL;
@property (weak, nonatomic) IBOutlet UIImageView *thumbL;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumL;
@property (weak, nonatomic) IBOutlet UILabel *pcNameL;
@property (weak, nonatomic) IBOutlet UILabel *supplyIDL;
@property (weak, nonatomic) IBOutlet UILabel *shipTimeL;
@property (weak, nonatomic) IBOutlet UILabel *feeL;
@property (weak, nonatomic) IBOutlet UILabel *pack_sourceL;
@property (weak, nonatomic) IBOutlet UILabel *startCountL;

@property (weak, nonatomic) IBOutlet UILabel *notSupportAreaL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@end

@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.selected = NO;
}

- (void)updateCellData:(SupplierModel *)model
{
    _model = model;
    self.saleNumL.text = [NSString stringWithFormat:@"已出货%@件",model.sales_number];
    self.saleNumL.textColor = [UIColor whiteColor];
    self.saleNumL.backgroundColor = [UIColor blueColor];
    
    [self.thumbL sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    
    self.goodsNumL.text = [NSString stringWithFormat:@"库存%@件",model.goods_number];
    
    self.pcNameL.text = [NSString stringWithFormat:@"%@ %@",model.province_name,model.city_name];
    self.pcNameL.textColor = [UIColor redColor];
    
    self.supplyIDL.text = [NSString stringWithFormat:@"ID:%03d",[model.suppliers_id intValue]];
    self.supplyIDL.textColor = [UIColor orangeColor];
    
    self.shipTimeL.text = model.shipping_time;
    
    self.feeL.text = [NSString stringWithFormat:@"配送费约%@元/桶",model.goods_shipping_fee];
    
    self.pack_sourceL.text = [NSString stringWithFormat:@"包装:%@ 产地:%@",model.goods_packing,model.goods_source];
    
    self.startCountL.text = [NSString stringWithFormat:@"起批量%@件",model.goods_start_count];
    
    self.notSupportAreaL.text = [NSString stringWithFormat:@"不支持购买地区:%@",model.city_name];
    self.notSupportAreaL.textColor = [UIColor orangeColor];
    
    self.priceL.text = model.shop_price;
    self.priceL.textColor = [UIColor blackColor];
    
}

- (IBAction)pressBtn:(id)sender
{
    GoodsDetailVC *gdvc = [[GoodsDetailVC alloc] init];
    if([_delegate respondsToSelector:@selector(presentVC: andVC:)])
    {
        [_delegate presentVC:self andVC:gdvc];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
