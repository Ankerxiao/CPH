//
//  BrandData.h
//  CPH
//
//  Created by keane on 16/7/14.
//  Copyright © 2016年 keane. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BrandData : JSONModel
@property (nonatomic,copy)NSString* brand_id;
@property (nonatomic,copy)NSString* brand_name;
@property (nonatomic,copy)NSString* brand_desc;
@property (nonatomic,copy)NSString* brand_logo;
@property (nonatomic,copy)NSString* url;
@end
