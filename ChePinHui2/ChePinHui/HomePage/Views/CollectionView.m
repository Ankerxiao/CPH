//
//  CollectionView.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/13.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "CollectionView.h"
#import "CVCell.h"

@interface CollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation CollectionView

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView andDelegate:(id)delegate
{
    if(self = [super init])
    {
        self.delegate = delegate;
        [self createCollectionView];
    }
    return self;
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *cvl = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH-64, SCREEN_HEIGHT) collectionViewLayout:cvl];
    [self addSubview:self.collectionView];
}

//cell的赋值
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([_delegate respondsToSelector:@selector(dataModelWithSection:andItem:)])
    {
        DataModel *model = [_delegate dataModelWithSection:indexPath.section andItem:indexPath.item];
        CVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        [cell updateCellData:model];
        return cell;
    }
    return nil;
}

- (void)refreshCollcetionView:(NSInteger)item
{
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([_delegate respondsToSelector:@selector(numOfCell)])
    {
        return [_delegate numOfCell];
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2);
}

//定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



@end
