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
    self.addressDict = dictAddress;
    self.recipients.text = dictAddress[@"consignee"];
    self.num.text = dictAddress[@"mobile"];
    self.detailAddress.text = [NSString stringWithFormat:@"%@ %@ %@ %@",dictAddress[@"province"],dictAddress[@"city"],dictAddress[@"district"],dictAddress[@"address_detail"]];
}

- (IBAction)isSelectBtn:(id)sender
{
    if(self.defaultBtn.selected == YES)
    {
        return;
    }
    
    //self.defaultBtn.selected = YES;
    if([_delegate respondsToSelector:@selector(setDefaultAddress: andCurrentButton:)])
    {
        [_delegate setDefaultAddress:_addressDict andCurrentButton:sender];
    }
    return;
}

- (IBAction)edit:(id)sender
{
    if([_delegate respondsToSelector:@selector(editAddress:)])
    {
        [_delegate editAddress:_addressDict];
    }
}

- (IBAction)delete:(id)sender
{
    if([_delegate respondsToSelector:@selector(deleteAddress:)])
    {
        [_delegate deleteAddress:_addressDict];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
