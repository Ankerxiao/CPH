//
//  AdvCell.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface AdvCell : UITableViewCell

@property (nonatomic,strong) DataModel *model;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@end
