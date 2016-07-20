//
//  AdData.h
//  CPH
//
//  Created by keane on 16/7/14.
//  Copyright © 2016年 keane. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AdData : JSONModel
@property (nonatomic,copy)NSString* ad_id;
@property (nonatomic,copy)NSString* position_id;
@property (nonatomic,copy)NSString* media_type;
@property (nonatomic,copy)NSString* ad_link;
@property (nonatomic,copy)NSString* ad_code;
@property (nonatomic,copy)NSString* link_man;
@property (nonatomic,copy)NSString* ad_name;
@property (nonatomic,copy)NSString* code_number;
@property (nonatomic,copy)NSString* ad_width;
@property (nonatomic,copy)NSString* position_name;
@property (nonatomic,copy)NSString* ad_height;
@end
