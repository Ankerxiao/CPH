//
//  AddressCell.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/20.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressCellDelegate <NSObject>

@optional
- (void)passValue;
- (void)deleteAddress:(NSDictionary *)dict;
- (void)editAddress:(NSDictionary *)dict;
- (void)setDefaultAddress:(NSDictionary *)dict andCurrentButton:(UIButton *)button;

@end

@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (nonatomic,weak) id <AddressCellDelegate> delegate;
@property (nonatomic,copy) NSDictionary *addressDict;
- (void)updateContentInCell:(NSDictionary *)dictAddress;

- (IBAction)isSelectBtn:(id)sender;
@end
