//
//  GoodsPicModel.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/18.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GoodsPicModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *img_id;
@property (nonatomic,copy) NSString <Optional> *img_url;
@property (nonatomic,copy) NSString <Optional> *thumb_url;
@end
