//
//  CollectionView.h
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/13.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@protocol CollectionViewDelegate <NSObject>

//返回指定cell的数据源
- (DataModel *)dataModelWithSection:(NSInteger)section andItem:(NSInteger)item;

//载入数据、刷新数据
- (void)loadData:(NSInteger)item;

//collectionView有多少个cell
- (NSInteger)numOfCell;

@end


@interface CollectionView : UIView

@property (nonatomic,weak) id <CollectionViewDelegate> delegate;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView andDelegate:(id)delegate;
- (void)refreshCollcetionView:(NSInteger)item;

@end
