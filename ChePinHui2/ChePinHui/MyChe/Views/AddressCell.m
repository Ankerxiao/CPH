//
//  AddressCell.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/20.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "AddressCell.h"
@interface AddressCell ()
{
    BOOL _isFirst;
    UIButton *_gBtn;
}
@property (weak, nonatomic) IBOutlet UILabel *recipients;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;


@end

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _isFirst = YES;
}

- (void)updateContentInCell:(NSDictionary *)dictAddress
{
    self.recipients.text = dictAddress[@"consignee"];
    self.num.text = dictAddress[@"mobile"];
    self.detailAddress.text = [NSString stringWithFormat:@"%@ %@ %@ %@",dictAddress[@"province"],dictAddress[@"city"],dictAddress[@"district"],dictAddress[@"address_detail"]];

}

- (IBAction)isSelectBtn:(id)sender
{
    static BOOL isFirst = YES;
    if(isFirst)
    {
        _gBtn = (UIButton *)sender;
        isFirst = NO;
    }
    else
    {
        _gBtn.selected = NO;
    }
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    _gBtn = btn;
}

- (IBAction)edit:(id)sender
{
    
}

- (IBAction)delete:(id)sender
{
    if([_delegate respondsToSelector:@selector(deleteAddress)])
    {
        [_delegate deleteAddress];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
