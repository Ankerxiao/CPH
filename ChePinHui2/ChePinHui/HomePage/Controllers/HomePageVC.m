//
//  HomePageVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

//My
#import "HomePageVC.h"
#import "NetManager.h"
#import "DataModel.h"
#import "UIImageView+WebCache.h"
#import "AdvCell.h"
#import "GoodsVC.h"
#import "GoodsDetailVC.h"

#define API_SERVER @"http://127.0.0.1/mcmp1605/data_enter.php"
#define GET_HOME_DATA @"method=home_info"
#define GET_HOME_CAT_DATA @"method=home_good_info&cat_type=%ld&page_num=%ld"

//teacher
#import "AdData.h"
#import "GoodsData.h"
#import "BrandData.h"
#import "GoodsCell.h"
#import "BrandCell.h"
#import "CatADReusableView.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#define SearchBar_H (40)
#define ADScrollV_H (150)
#define BTN_LIST_V_H (60)

#define BTN_H (40)
#define BTN_W ((SCREEN_WIDTH-20)/3)
#define BTN_DISTANCE (10)



static NSString *cellID = @"cellID";
static NSString *headViewID = @"headerview";
static NSString *footViewID = @"footerview";
static NSString *sectionViewID = @"sectionview";

@interface HomePageVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchControllerDelegate,UISearchResultsUpdating,UIScrollViewDelegate>
{
    UISearchController *_searchC;
    BOOL _isFirst;
    NSInteger _index;
    UIScrollView *_scrollView;
}
@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,strong) NSArray *advDataArray;
@property (nonatomic,strong) NSArray *catArray;


//teacher
//搜索框
@property (nonatomic,strong)UISearchBar*searchBar;
//广告scrollView
@property (nonatomic,strong)UIScrollView* adScrollView;

//按钮的父View
@property (nonatomic,strong)UIView *btnListView;
//汽油按钮
@property (nonatomic,strong)UIButton *btn1;
//柴油按钮
@property (nonatomic,strong)UIButton *btn2;
//品牌按钮
@property (nonatomic,strong)UIButton *btn3;

//商品collectionView所在的scrollview
@property (nonatomic,strong)UIScrollView *collectionsScrollView;
@property (nonatomic,strong)UICollectionView *collectionV1;
@property (nonatomic,strong)UICollectionView *collectionV2;
@property (nonatomic,strong)UICollectionView *collectionV3;



@property (nonatomic,strong)NSMutableArray *adArray;
@property (nonatomic,strong)NSMutableArray *catAdArray;
@property (nonatomic,strong)NSMutableArray *cat1Array;
@property (nonatomic,strong)NSMutableArray *cat2Array;
@property (nonatomic,strong)NSMutableArray *cat3Array;


@property (nonatomic,assign)BOOL goodsListIsOpen;//


@property (nonatomic,strong)UIView *bottomLineV;
@property (nonatomic,strong) UIImageView *imageV1;
@property (nonatomic,strong) UIImageView *imageV2;
@property (nonatomic,strong) UIImageView *imageV3;

@property (nonatomic,assign)NSInteger collection1PageNum;
@property (nonatomic,assign)NSInteger collection2PageNum;

@end

@implementation HomePageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    
    [self initData];
    [self initSubViews];
    [self loadData];
    
    
    //本人代码
//    [self.view addSubview:self.tableV];
//    [self getDataFromServer];
    
}

//老师代码
- (void)initData
{
    _adArray = [[NSMutableArray alloc] init];
    _catAdArray = [[NSMutableArray alloc] init];
    _cat1Array = [[NSMutableArray alloc] init];
    _cat2Array = [[NSMutableArray alloc] init];
    _cat3Array = [[NSMutableArray alloc] init];
}

- (void)initSubViews
{
    //searchBar的初始化
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SearchBar_H)];
    [self.view addSubview:_searchBar];
    
    //广告位的初始化
    _adScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SearchBar_H, SCREEN_WIDTH, ADScrollV_H)];
    [_adScrollView setBackgroundColor:[UIColor redColor]];
    _adScrollView.pagingEnabled = YES;
    [self.view addSubview:_adScrollView];
    
    
    _btnListView = [[UIView alloc] initWithFrame:CGRectMake(0, SearchBar_H+ADScrollV_H, SCREEN_WIDTH, BTN_LIST_V_H)];
    [_btnListView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_btnListView];
    
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.tag = 100;
    [_btn1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btn1 setTitle:@"汽机油" forState:UIControlStateNormal];
    _btn1.frame =CGRectMake(-20, BTN_DISTANCE, BTN_W, BTN_H);
    
    _btn1.selected = YES;
    [_btn1 addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    _imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(75, 15, 20, 30)];
    if(_btn1.selected)
    {
        _imageV1.image = [UIImage imageNamed:@"qijiyou_h"];
    }
    else
    {
        _imageV1.image = [UIImage imageNamed:@"qijiyou_n"];
    }
//    _imageV1.image = [UIImage imageNamed:@"qijiyou_h"];
//    [_btn1 setBackgroundImage:[UIImage imageNamed:@"qijiyou_h"] forState:UIControlStateSelected];
//    [_btn1 setBackgroundImage:[UIImage imageNamed:@"qijiyou_n"] forState:UIControlStateNormal];
    [_btnListView addSubview:_btn1];
    
    [_btnListView addSubview:_imageV1];
    
    
    //加上滚动条
    _bottomLineV = [[UIView alloc] initWithFrame:CGRectMake(0,_btnListView.frame.size.height-2, BTN_W, 2)];
    [_bottomLineV setBackgroundColor:[UIColor redColor]];
    [_btnListView addSubview:_bottomLineV];
    
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn2.tag = 101;
    [_btn2 setTitle:@"柴机油" forState:UIControlStateNormal];
    _btn2.frame =CGRectMake(BTN_W+BTN_DISTANCE-20, BTN_DISTANCE, BTN_W, BTN_H);
    [_btn2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btn2 addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    [_btnListView addSubview:_btn2];
    _imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(75+BTN_W+BTN_DISTANCE, 15, 20, 30)];
    _imageV2.image = [UIImage imageNamed:@"caijiyou_n"];
    [_btnListView addSubview:_imageV2];
    
    
    _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn3.tag = 102;
    [_btn3 setTitle:@"品牌" forState:UIControlStateNormal];
    _btn3.frame =CGRectMake(BTN_W*2+BTN_DISTANCE*2-20, BTN_DISTANCE, BTN_W, BTN_H);
    [_btn3 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btn3 addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    [_btnListView addSubview:_btn3];
    _imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(75+(BTN_W+BTN_DISTANCE)*2, 15, 20, 30)];
    _imageV3.image = [UIImage imageNamed:@"pinpai_n"];
    [_btnListView addSubview:_imageV3];
    
    
    _collectionsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SearchBar_H+ADScrollV_H+BTN_LIST_V_H, SCREEN_WIDTH, SCREEN_HEIGHT-(SearchBar_H+ADScrollV_H+BTN_LIST_V_H)-64-49+SearchBar_H+ADScrollV_H)];
    _collectionsScrollView.delegate = self;
    _collectionsScrollView.pagingEnabled = YES;
    _collectionsScrollView.showsHorizontalScrollIndicator = NO;
    [_collectionsScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*3, _collectionsScrollView.frame.size.height)];
    [self.view addSubview:_collectionsScrollView];
    
    
    for (int i=0; i<3; i++) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/2-10, SCREEN_WIDTH/2-10);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        
        
        UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, _collectionsScrollView.frame.size.height) collectionViewLayout:flowLayout];
        [collectionV setBackgroundColor:[UIColor greenColor]];
        
        collectionV.delegate = self;
        collectionV.dataSource = self;
        
        
        [collectionV registerClass:[CatADReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseID"];
        
        if(i == 0){
            [collectionV registerNib:[UINib nibWithNibName:@"GoodsCell" bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"CELL_%d",i]];
            self.collectionV1 = collectionV;
            
            self.collectionV1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                NSLog(@"#######");
                [self upRefeshData:0 andPageNumber:++_collection1PageNum];
                
            }];
            
            
        }else if(i == 1){
            [collectionV registerNib:[UINib nibWithNibName:@"GoodsCell" bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"CELL_%d",i]];
            self.collectionV2 = collectionV;
            
            self.collectionV2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                NSLog(@"#######");
                [self upRefeshData:1 andPageNumber:++_collection2PageNum];
            }];
            
        }else if(i == 2){
            [collectionV registerNib:[UINib nibWithNibName:@"BrandCell" bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"CELL_%d",i]];
            self.collectionV3 = collectionV;
            
            
        }
        [_collectionsScrollView addSubview:collectionV];
        
    }
    
    
}

//method=home_good_info&cat_type=%ld&page_num=%ld
- (void)upRefeshData:(NSInteger)type andPageNumber:(NSInteger)page
{
    NSString* urlStr = @"http://127.0.0.1/mcmp1605/data_enter.php?method=home_good_info&cat_type=%ld&page_num=%ld";
    urlStr = [NSString stringWithFormat:urlStr,type,page];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sessionManager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        for (NSDictionary *dicTemp in dic[@"data"][@"goods_list"]) {
            GoodsData *goodsData = [[GoodsData alloc] initWithDictionary:dicTemp error:nil];
            
            if(type == 0){
                [_cat1Array addObject:goodsData];
            }else if(type == 1){
                [_cat2Array addObject:goodsData];
            }
            
        }
        
        
        //刷新第一种商品的collectionView
        dispatch_async(dispatch_get_main_queue(), ^{
            if(type == 0){
                [_collectionV1 reloadData];
                _collection1PageNum++;
                [_collectionV1.mj_footer endRefreshing];
            }else if(type ==1){
                [_collectionV2 reloadData];
                _collection2PageNum++;
                [_collectionV2.mj_footer endRefreshing];
            }
        });
        NSLog(@"%@",_adArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)loadData
{
    NSString* urlStr = @"http://127.0.0.1/mcmp1605/data_enter.php?method=home_info";
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sessionManager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",dic);
        
        //拿到滚动广告数据
        for (NSDictionary *dicTemp in dic[@"data"][@"adFoucsArray"]) {
            AdData *adData = [[AdData alloc] initWithDictionary:dicTemp error:nil];
            [_adArray addObject:adData];
        }
        
        //更新广告scrollview
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateADScrollView];
        });
        
        //拿到每个种类的广告数据
        for (NSDictionary *dicTemp in dic[@"data"][@"adCatArray"]) {
            AdData *adData = [[AdData alloc] initWithDictionary:dicTemp error:nil];
            [_catAdArray addObject:adData];
        }
        
        //拿到第一种商品数据
        for (NSDictionary *dicTemp in dic[@"data"][@"cat1Data"][@"goods_list"]) {
            GoodsData *goodsData = [[GoodsData alloc] initWithDictionary:dicTemp error:nil];
            [_cat1Array addObject:goodsData];
        }
        //刷新第一种商品的collectionView
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionV1 reloadData];
        });
        
        //拿到第二种商品数据
        for (NSDictionary *dicTemp in dic[@"data"][@"cat2Data"][@"goods_list"]) {
            GoodsData *goodsData = [[GoodsData alloc] initWithDictionary:dicTemp error:nil];
            [_cat2Array addObject:goodsData];
        }
        //刷新第二种商品的collectionView
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionV2 reloadData];
        });
        
        
        //拿到商品所有品牌数据
        for (NSDictionary *dicTemp in dic[@"data"][@"brandData"][@"brand"]) {
            BrandData *goodsData = [[BrandData alloc] initWithDictionary:dicTemp error:nil];
            [_cat3Array addObject:goodsData];
        }
        //刷新第3个collectionView
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionV3 reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)updateADScrollView
{
    for (int i = 0; i < [_adArray count]; i++)
    {
        AdData *adData = _adArray[i];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, ADScrollV_H)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meichemeipin.com/mobile/data/afficheimg/%@",adData.ad_code]]];
        [_adScrollView addSubview:imgV];
    }
    [_adScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*[_adArray count], ADScrollV_H)];
}

- (void)btnPress:(UIButton*)btn
{
    NSInteger tag = btn.tag - 100;
    [_collectionsScrollView setContentOffset:CGPointMake(tag*SCREEN_WIDTH, 0) animated:YES];

    _btn1.selected = NO;
    _btn2.selected = NO;
    _btn3.selected = NO;
    
    btn.selected = YES;
    
    if(_btn1.selected)
    {
        _imageV1.image = [UIImage imageNamed:@"qijiyou_h"];
    }
    else
    {
        _imageV1.image = [UIImage imageNamed:@"qijiyou_n"];
    }
    if(_btn2.selected)
    {
        _imageV2.image = [UIImage imageNamed:@"caijiyou_h"];
    }
    else
    {
        _imageV2.image = [UIImage imageNamed:@"caijiyou_n"];
    }
    if(_btn3.selected)
    {
        _imageV3.image = [UIImage imageNamed:@"pinpai_h"];
    }
    else
    {
        _imageV3.image = [UIImage imageNamed:@"pinpai_n"];
    }
    //移动红色滚动条
    [UIView animateWithDuration:0.5 animations:^{
        _bottomLineV.frame = CGRectMake(btn.frame.origin.x,_btnListView.frame.size.height-2, BTN_W, 2);
    }];
}



#pragma mark CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:_collectionV1])
    {
        return [_cat1Array count];
    }else if([collectionView isEqual:_collectionV2]){
        return [_cat2Array count];
    }else if([collectionView isEqual:_collectionV3]){
        return [_cat3Array count];
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_collectionV1]) {
        
        GoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_0" forIndexPath:indexPath];
        
        [cell updateCellData:_cat1Array[indexPath.row]];
        return cell;
        
    }else if([collectionView isEqual:_collectionV2]){
        GoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_1" forIndexPath:indexPath];
        [cell updateCellData:_cat2Array[indexPath.row]];
        return cell;
    }else if([collectionView isEqual:_collectionV3]){
        BrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_2" forIndexPath:indexPath];
        [cell updateCellData:_cat3Array[indexPath.row]];
        return cell;
    }
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([_catAdArray count] == 0)
    {
        return nil;
    }
    
    CatADReusableView* v = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseID" forIndexPath:indexPath];
    
    if([collectionView isEqual:_collectionV1]){
        AdData *ad = _catAdArray[0];
        [v updateData:ad];
    }else if([collectionView isEqual:_collectionV2]){
        AdData *ad = _catAdArray[1];
        [v updateData:ad];
    }else if([collectionView isEqual:_collectionV3]){
        AdData *ad = _catAdArray[2];
        [v updateData:ad];
    }
    
    return v;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if([_catAdArray count] == 0)
    {
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH, 100);
}

#pragma mark 选中某个item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:_collectionV1])
    {
        GoodsData *data = _cat1Array[indexPath.item];
        GoodsDetailVC *vc = [[GoodsDetailVC alloc] init];
        vc.goodsID = data.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([collectionView isEqual:_collectionV2])
    {
        GoodsData *data = _cat2Array[indexPath.item];
        GoodsDetailVC *vc = [[GoodsDetailVC alloc] init];
        vc.goodsID = data.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([scrollView isMemberOfClass:[UIScrollView class]])
    {
        NSInteger collectIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
        
        _btn1.selected = NO;
        _btn2.selected = NO;
        _btn3.selected = NO;
        
        UIButton *btn = [_btnListView viewWithTag:100+collectIndex];
        btn.selected = YES;
        
        
        if(_btn1.selected)
        {
            _imageV1.image = [UIImage imageNamed:@"qijiyou_h"];
        }
        else
        {
            _imageV1.image = [UIImage imageNamed:@"qijiyou_n"];
        }
        if(_btn2.selected)
        {
            _imageV2.image = [UIImage imageNamed:@"caijiyou_h"];
        }
        else
        {
            _imageV2.image = [UIImage imageNamed:@"caijiyou_n"];
        }
        if(_btn3.selected)
        {
            _imageV3.image = [UIImage imageNamed:@"pinpai_h"];
        }
        else
        {
            _imageV3.image = [UIImage imageNamed:@"pinpai_n"];
        }

        
        //移动红色滚动条
        [UIView animateWithDuration:0.3 animations:^{
            _bottomLineV.frame = CGRectMake(btn.frame.origin.x,_btnListView.frame.size.height-2, BTN_W, 2);
        }];
        return;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isMemberOfClass:[UIScrollView class]])
    {
        return;
    }
    if(scrollView.contentOffset.y > 10 && _goodsListIsOpen == NO)
    {
        [UIView beginAnimations:nil context:nil];
        _searchBar.frame = CGRectOffset(_searchBar.frame, 0, -1*(SearchBar_H+ADScrollV_H));
        _adScrollView.frame =CGRectOffset(_adScrollView.frame, 0, -1*(SearchBar_H+ADScrollV_H));
        _btnListView.frame = CGRectOffset(_btnListView.frame, 0, -1*(SearchBar_H+ADScrollV_H));
        _collectionsScrollView.frame = CGRectOffset(_collectionsScrollView.frame, 0, -1*(SearchBar_H+ADScrollV_H));
        
        _goodsListIsOpen = YES;
        [UIView commitAnimations];
    }
    
    if(_goodsListIsOpen == YES && scrollView.contentOffset.y < -10){
        [UIView beginAnimations:nil context:nil];
        _searchBar.frame = CGRectOffset(_searchBar.frame, 0, (SearchBar_H+ADScrollV_H));
        _adScrollView.frame =CGRectOffset(_adScrollView.frame, 0, (SearchBar_H+ADScrollV_H));
        _btnListView.frame = CGRectOffset(_btnListView.frame, 0, (SearchBar_H+ADScrollV_H));
        _collectionsScrollView.frame = CGRectOffset(_collectionsScrollView.frame, 0, (SearchBar_H+ADScrollV_H));
        
        _goodsListIsOpen = NO;
        [UIView commitAnimations];
    }
}



//本人代码
//- (UITableView *)tableV
//{
//    if(nil == _tableV)
//    {
//        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
//        _tableV.delegate = self;
//        _tableV.dataSource = self;
//        _searchC = [[UISearchController alloc] initWithSearchResultsController:nil];
//        _searchC.delegate = self;
//        _searchC.searchResultsUpdater = self;
//        //_searchC.hidesNavigationBarDuringPresentation = YES;
//        //_searchC.dimsBackgroundDuringPresentation = NO;
//        _searchC.obscuresBackgroundDuringPresentation = NO;
//        _searchC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
//        _searchC.searchBar.placeholder = @"查找";
//        _tableV.tableHeaderView = _searchC.searchBar;
//    }
//    return _tableV;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if(section == 1)
//    {
//        return 44; //四个分类
//    }
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == 1)
//    {
//        return self.collectionV.contentSize.height;
//    }
//    return 200;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *str = @"cellID";
//    AdvCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
//    if(!cell)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"AdvCell" owner:nil options:nil] lastObject];
//    }
//    if(indexPath.section == 1)
//    {
//        [cell addSubview:[self createFourCollectionViewOnScrollView]];
//        return cell;
//    }
//    if(indexPath.section == 0)
//    {
//        [cell addSubview:[self createScrollVAndSection:0]];
//    }
//    return cell;
//}
//
//#pragma mark 创建两个广告位，第一个广告位是ScrollView，第二个就是一个UIView，collectionView的头视图
//- (UIView *)createScrollVAndSection:(NSInteger)section
//{
//    if(section == 0)
//    {
//        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//        NSInteger count = [self.advDataArray[section] count];
//        for(int i=0;i<count;i++)
//        {
//            DataModel *model = [[DataModel alloc] init];
//            model = self.advDataArray[section][i];
//            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",COMMON_PIC_API,model.ad_code]);
//            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",COMMON_PIC_API,model.ad_code]]];
//            [sv addSubview:imageV];
//        }
//        sv.pagingEnabled = YES;
//        sv.showsHorizontalScrollIndicator = YES;
//        sv.contentSize = CGSizeMake(count*SCREEN_WIDTH, 0);
//        return sv;
//    }
//    if(section == 1)
//    {
////        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
////        DataModel *model = [[DataModel alloc] init];
////        model = self.advDataArray[section][0]; //0,1,2三个分类的广告
////        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
////        NSLog(@"%@",[NSString stringWithFormat:@"%@%@",COMMON_PIC_API,model.ad_code]);
////        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",COMMON_PIC_API,model.ad_code]]];
////        [vw addSubview:imageV];
////        return vw;
//        
////        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1000)];
////        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1000)];
//        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4*SCREEN_WIDTH, 200)];
//        for(int i=0;i<3;i++)
//        {
//            DataModel *model = [[DataModel alloc] init];
//            model = self.advDataArray[section][i]; //0,1,2三个分类的广告
//            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, 200)];
//            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",COMMON_PIC_API,model.ad_code]);
//            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",COMMON_PIC_API,model.ad_code]]];
//            [vw addSubview:imageV];
//        }
//        _scrollView.contentSize = CGSizeMake(4*SCREEN_WIDTH, 0);
//        return vw;
//    }
//    return nil;
//}
//
//#pragma mark 第二组的头视图 即四个分类
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(section == 1)
//    {
//        //四个分类 第二组的头视图
//        return [self createFourCategory];
//    }
//    return nil;
//}
//
//- (UIView *)createFourCategory
//{
//    NSArray *currentImage = @[@"qijiyou_h",@"caijiyou_h",@"pinpai_h",@"big"];
//    NSArray *unselectImage = @[@"qijiyou_n",@"caijiyou_n",@"pinpai_n",@"big"];
//    NSArray *title = @[@"汽机油",@"柴机油",@"品牌",@"大批发"];
//    _isFirst = YES;
//    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    for(int i=0;i<4;i++)
//    {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 40)];
//        btn.tag = 1+i;//btn的tag
//        UIImageView *imageV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:unselectImage[i]]];
//        imageV2.frame = CGRectMake(0, 0, btn.frame.size.width/2, 40);
//        [btn addSubview:imageV2];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2, 0, btn.frame.size.width/2, 40)];
//        label.tag = 10+i;
//        label.text = title[i];
//        label.font = [UIFont systemFontOfSize:13];
//        [btn addSubview:label];
//        
//        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [vw addSubview:btn];
//        
//        //默认选中第一个
//        if(i == 0)
//        {
//            UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:currentImage[i]]];
//            imageV.tag = 20;
//            imageV.frame = imageV2.frame;
//            label.textColor = [UIColor redColor];
//            [btn addSubview:imageV];
//            UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame)-2, btn.frame.size.width, 2)];
//            underline.tag = 30;
//            underline.backgroundColor = [UIColor redColor];
//            [btn addSubview:underline];
//        }
//    }
//    return vw;
//}
//
//- (void)pressBtn:(UIButton *)btn
//{
//    static NSInteger lastTag = 1;
//    if(btn.tag == lastTag)
//    {
//        return;
//    }
//    
//    //取消上次按钮的颜色
//    UIButton *lastBtn = [self.tableV viewWithTag:lastTag];
//    for(UIView *vw in lastBtn.subviews)
//    {
//        if([vw isKindOfClass:[UILabel class]])
//        {
//            UILabel *label = (UILabel *)vw;
//            label.textColor = [UIColor blackColor];
//        }
//        if(vw.tag == 20) //图片
//        {
//            [vw removeFromSuperview];
//        }
//        if(vw.tag == 30) //下划线
//        {
//            [vw removeFromSuperview];
//        }
//    }
//    
//    //修改本次按钮上控件的颜色
//    NSArray *currentImage = @[@"qijiyou_h",@"caijiyou_h",@"pinpai_h",@"big"];
//    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:currentImage[btn.tag-1]]];
//    imageV.frame = CGRectMake(0, 0, btn.frame.size.width/2, 40);
//    [btn addSubview:imageV];
//    imageV.tag = 20;
//    UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)-2, SCREEN_WIDTH/4, 2)];
//    underline.backgroundColor = [UIColor redColor];
//    underline.tag = 30;
//    for(UIView *vw in btn.subviews)
//    {
//        if([vw isKindOfClass:[UILabel class]])
//        {
//            UILabel *label = (UILabel *)vw;
//            label.textColor = [UIColor redColor];
//        }
//    }
//    [btn addSubview:underline];
//    lastTag = btn.tag;
//    
//    //翻到第二页
//    
//}
//
//#pragma mark 创建四个CollectionView，并加到ScrollView
//- (UIScrollView *)createFourCollectionViewOnScrollView
//{
//    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    sv.pagingEnabled = YES;
//    
//    UIView *vw = [self createScrollVAndSection:1];
////    vw.frame = CGRectMake(4*SCREEN_WIDTH, 0, SCREEN_WIDTH, 200);
//    [sv addSubview:vw];
//    
//    for(int i=0;i<4;i++)
//    {
//        UICollectionView *cv = [self createCollectionView:i];
//        cv.frame = CGRectMake(i*SCREEN_WIDTH, 200, SCREEN_WIDTH, SCREEN_HEIGHT);
//        cv.delegate = self;
//        cv.dataSource = self;
//        [cv reloadData];
//        [sv addSubview:cv];
//    }
//    sv.contentSize = CGSizeMake(4*SCREEN_WIDTH, 0);
//    return sv;
//}
//
////- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
////{
////    [self createScrollVAndSection:1];
////}
//
//- (UICollectionView *)createCollectionView:(NSInteger)section
//{
//    switch (section)
//    {
//        case 0:
//            //汽机油
//        {
//            _index = 0;
//            UICollectionView *cv = [self createCV];
//            return cv;
//        }
//            break;
//        case 1:
//            //柴机油
//        {
//            _index = 1;
//            UICollectionView *cv = [self createCV];
//            return cv;
//        }
//            break;
//        case 2:
//            //品牌
//        {
//            _index = 2;
//            UICollectionView *cv = [self createCV];
//            return cv;
//        }
//            break;
//        case 3:
//            //大批发
//        {
//            _index = 3;
//            UICollectionView *cv = [self createCV];
//            return cv;
//        }
//            break;
//        default:
//            break;
//    }
//    return nil;
//}
//
//#pragma mark collectionV，dataArray，catArray的懒加载
//- (UICollectionView *)collectionV
//{
////    if(nil == _collectionV)
////    {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
////        _collectionV.delegate = self;
////        _collectionV.dataSource = self;
//        [_collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
//        _collectionV.backgroundColor = [UIColor whiteColor];
////        [_collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headViewID];
//        _collectionV.contentSize = CGSizeMake(SCREEN_WIDTH, [self.catArray[0] count]*SCREEN_WIDTH/4);
////    }
//    return _collectionV;
//}
//
//- (UICollectionView *)createCV
//{
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
////    cv.delegate = self;
////    cv.dataSource = self;
//    static int i = 0;
//    NSString *str = [NSString stringWithFormat:@"%@_%d",cellID,i];
//    [cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
//    cv.backgroundColor = [UIColor whiteColor];
//    cv.contentSize = CGSizeMake(SCREEN_WIDTH, [self.catArray[0] count]*SCREEN_WIDTH/4);
//    i++;
//    return cv;
//}
//
//- (NSArray *)dataArray
//{
//    if(nil == _advDataArray)
//    {
//        _advDataArray = [NSArray array];
//    }
//    return _advDataArray;
//}
//
//- (NSArray *)catArray
//{
//    if(nil == _catArray)
//    {
//        _catArray = [NSArray array];
//    }
//    return _catArray;
//}
//
//#pragma mark JSON解析，结果存放到advDataArray和catArray两个数组中
//- (void)getDataFromServer
//{
//    NetManager *nm = [NetManager shareManager];
//    [nm requestStrUrl:[NSString stringWithFormat:@"%@?%@",API_SERVER,GET_HOME_DATA] withSuccessBlock:^(id data) {
//        NSArray *array1 = data[@"data"][@"adFoucsArray"];
//        NSArray *array2 = data[@"data"][@"adCatArray"];
//        NSMutableArray *temp1 = [NSMutableArray array];
//        NSMutableArray *temp2 = [NSMutableArray array];
//        for(NSDictionary *dict in array1)
//        {
//            DataModel *model = [[DataModel alloc] initWithDictionary:dict error:nil];
//            [temp1 addObject:model];
//            NSLog(@"%@",dict);
//        }
//        for(NSDictionary *dict in array2)
//        {
//            DataModel *model = [[DataModel alloc] initWithDictionary:dict error:nil];
//            [temp2 addObject:model];
//            NSLog(@"%@",dict);
//        }
//        self.advDataArray = @[temp1,temp2]; //广告位图片信息
//        
//        NSMutableArray *temp3 = [NSMutableArray array];
//        NSMutableArray *temp4 = [NSMutableArray array];
//        NSMutableArray *temp5 = [NSMutableArray array];
//        NSMutableArray *temp6 = [NSMutableArray array];
//        for(NSDictionary *dict in data[@"data"][@"cat1Data"][@"goods_list"])
//        {
//            DataModel *model = [[DataModel alloc] initWithDictionary:dict error:nil];
//            [temp3 addObject:model];
//        }
//        for(NSDictionary *dict in data[@"data"][@"cat2Data"][@"goods_list"])
//        {
//            DataModel *model = [[DataModel alloc] initWithDictionary:dict error:nil];
//            [temp4 addObject:model];
//        }
//        for(NSDictionary *dict in data[@"data"][@"cat3Data"][@"goods_list"])
//        {
//            DataModel *model = [[DataModel alloc] initWithDictionary:dict error:nil];
//            [temp5 addObject:model];
//        }
//        for(NSDictionary *dict in data[@"data"][@"brandData"][@"brand"])
//        {
//            DataModel *model = [[DataModel alloc] initWithDictionary:dict error:nil];
//            [temp6 addObject:model];
//        }
//        self.catArray = @[temp3,temp4,temp5,temp6];
//        
//        [self.view addSubview:self.tableV];
//    } withFailedBlock:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//}
//
//#pragma mark CollectionView的代理
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    NSInteger count = [self.catArray[section] count];
//    return count;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static int i = 0;
//    NSString *str = [NSString stringWithFormat:@"%@_%d",cellID,i];
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_WIDTH/2)];
//    DataModel *model = [[DataModel alloc] init];
//    model = self.catArray[0][indexPath.item]; //0，1，2，3四个分类下的各个商品
//    //商品图片
//    UIImageView *imageV = [[UIImageView alloc] init];
//    imageV.frame = CGRectMake(10, 10, 110, 110);
//    NSLog(@"%@",model.goods_thumb);
//    [imageV sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
//    
//    //商品标题
//    UILabel *nameL = [[UILabel alloc] init];
//    nameL.frame = CGRectMake(imageV.frame.origin.x, CGRectGetMaxY(imageV.frame)+5, SCREEN_WIDTH/2, 40);
//    nameL.numberOfLines = 0;
//    nameL.font = [UIFont systemFontOfSize:13];
//    nameL.text = model.name;
//    
//    //商品价格
//    UILabel *priceL = [[UILabel alloc] init];
//    priceL.frame = CGRectMake(nameL.frame.origin.x, CGRectGetMaxY(nameL.frame)+5, SCREEN_WIDTH/2, 20);
//    priceL.text = [NSString stringWithFormat:@"最低价:%@",model.shop_price];
//    priceL.textColor = [UIColor redColor];
//    priceL.font = [UIFont systemFontOfSize:12];
//    
//    //加到bgView
//    [bgView addSubview:imageV];
//    [bgView addSubview:nameL];
//    [bgView addSubview:priceL];
//    
//    cell.backgroundView = bgView;
//    i++;
//    return cell;
//}
//
////定义每个UICollectionView的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2);
//}
//
////定义每个UICollectionView的margin
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
//#pragma mark 选中collectionView的某个item
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor yellowColor];
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
#pragma mark 搜索结果的回调
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{

}
//
//#pragma mark 广告位的ScrollView
//- (UIScrollView *)createAdvScrollView
//{
//    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//    NSInteger count = self.advDataArray.count;
//    for(int i=0;i<count;i++)
//    {
//        DataModel *model = [[DataModel alloc] init];
//        model = self.advDataArray[i];
//        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//        [imageV sd_setImageWithURL:[NSURL URLWithString:model.ad_link]];
//        [sv addSubview:imageV];
//    }
//    sv.pagingEnabled = YES;
//    sv.showsHorizontalScrollIndicator = YES;
//    sv.contentSize = CGSizeMake(count*SCREEN_WIDTH, 0);
//    return sv;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
