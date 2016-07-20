//
//  CartCell.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/19.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "CartCell.h"
#import <UIImageView+WebCache.h>
#import "NetManager.h"

#define API_SERVER @"http://10.11.57.27/mcmp1605/data_enter.php"
#define UPDATE_SHOPPING_NUM @"method=cart_update_num&session_id=%@&goods_id=%@&number=%@"

@interface CartCell () <UITextFieldDelegate>
{
    NSInteger _allPrice;
    NSMutableArray *_modelArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIButton *desBtn;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation CartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.numText.delegate = self;
}

- (instancetype)init
{
    if(self = [super init])
    {
        _purchaseNum = 0;
        _modelArray = [NSMutableArray array];
    }
    return self;
}

- (void)updateCellData:(CartModel *)model
{
    _purchaseNum = 0;
    _modelArray = [NSMutableArray array];
    
    
    _cartModel = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    self.nameL.text = model.goods_name;
    NSString *tempStr = [NSString stringWithFormat:@"￥%@",model.goods_price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tempStr attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    self.priceL.attributedText = str;
    self.numText.text = model.goods_number;
}

- (IBAction)des:(id)sender
{
    if([self.numText.text intValue] == 0)
    {
        return;
    }
    self.numText.text = [NSString stringWithFormat:@"%d",[self.numText.text intValue]-1];
    _cartModel.goods_number = self.numText.text;
    [self calcutePrice];
}

- (IBAction)add:(id)sender
{
    self.numText.text = [NSString stringWithFormat:@"%d",[self.numText.text intValue]+1];
    _cartModel.goods_number = self.numText.text;
    [self calcutePrice];
}

- (void)updateServerData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:UPDATE_SHOPPING_NUM,[ud objectForKey:@"session"],_cartModel.goods_id,self.numText.text];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,str];
    NetManager *nm = [NetManager shareManager];
    
    [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
        
    } withFailedBlock:^(NSError *error) {
        
    }];
}

- (IBAction)selected:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if(btn.selected)
    {
        _cartModel.isSelected = @"1";
    }
    else
    {
        _cartModel.isSelected = @"0";
    }
    [self calcutePrice];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",string);
    NSInteger purchaseNum = [_cartModel.goods_number integerValue];
    if([string isEqualToString:@""])
    {
        purchaseNum /= 10;
        _cartModel.goods_number = [NSString stringWithFormat:@"%ld",purchaseNum];
        [self calcutePrice];
        return YES;
    }
    NSString *str = [NSString stringWithFormat:@"%ld%@",purchaseNum,string];

    _cartModel.goods_number = [NSString stringWithFormat:@"%@",str];
    [self calcutePrice];
    return YES;
}

- (void)calcutePrice
{
    if([_delegate respondsToSelector:@selector(updatePrice:)])
    {
        [_delegate updatePrice:_cartModel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
