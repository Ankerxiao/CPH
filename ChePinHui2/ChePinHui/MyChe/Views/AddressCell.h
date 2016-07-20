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
- (void)deleteAddress;

@end

@interface AddressCell : UITableViewCell
@property (nonatomic,weak) id <AddressCellDelegate> delegate;
- (void)updateContentInCell:(NSDictionary *)dictAddress;
@end
