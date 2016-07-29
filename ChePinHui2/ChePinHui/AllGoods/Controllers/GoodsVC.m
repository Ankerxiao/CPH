//
//  GoodsVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "GoodsVC.h"
#import "CollectionView.h"
#import "DataModel.h"
#import "NetManager.h"
#import "CVCell.h"
#import "MJRefresh.h"
#import "TableCell.h"
#import "DetailTableView.h"



#define API_SERVER @"http://127.0.0.1/mcmp1605/data_enter.php"
#define GET_HOME_DATA @"method=home_info"
#define GET_HOME_CAT_DATA @"method=home_good_info&cat_type=%ld&page_num=%ld"

#define GET_GOODS_LIST_DATA @"method=goods_list&cat_type=%ld&page_num=%ld"
#define GET_SUPPLIER_LIST @"method=supplier_list&goods_id=%@&page_num=%ld" //供货商接口

@interface GoodsVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    UICollectionView *_coll;
    UIView *_suspensionView;
    BOOL _isFirst;
    NSString *_category;
    NSInteger _cat_type; //种类
    BOOL _order_way;//升序，降序
    BOOL _order;//销量，价格
    BOOL _isFirstLoadData;
    BOOL _isChangeLayout;
}
@property (nonatomic,strong) CollectionView *collec;
@property (nonatomic,strong) UITableView *tableV;
@end

@implementation GoodsVC

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //修改导航栏颜色，添加右侧按钮
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(changeLayout)];
    
    //初始化成员变量
    _dataArray = [NSMutableArray array];
    _isFirst = YES;
    _cat_type = 0;
    _order = 0;
    _order_way = 0;
    _isFirstLoadData = YES;
    _isChangeLayout = YES;
    
    //添加三个按钮
    [self createThreeBtn];
    _suspensionView = [self createSuspensionView:self.view.frame];
    _suspensionView.frame = CGRectMake(0, -90, SCREEN_WIDTH/3, 90);
    
    
    //添加collectionView，默认
    UICollectionViewFlowLayout *cvl = [[UICollectionViewFlowLayout alloc] init];
    _coll = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-143) collectionViewLayout:cvl];
    _coll.backgroundColor = [UIColor whiteColor];
    _coll.delegate = self;
    _coll.dataSource = self;
    [_coll registerNib:[UINib nibWithNibName:@"CVCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_coll];
    
    
    
    //上拉加载和下拉刷新
    _coll.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        NSString *goods_list = [NSString stringWithFormat:@"method=goods_list&cat_type=%ld&page_num=%d&order=%d&order_way=%d",_cat_type,1,_order+1,_order_way+1];
        NSLog(@"%@",[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]);
        [self getDataFromService:[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]];

    }];
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        NSString *goods_list = [NSString stringWithFormat:@"method=goods_list&cat_type=%ld&page_num=%d&order=%d&order_way=%d",_cat_type,1,_order+1,_order_way+1];
        NSLog(@"%@",[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]);
        [self getDataFromService:[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]];
    }];
    _coll.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        static int i=1;
        NSString *goods_list = [NSString stringWithFormat:@"method=goods_list&cat_type=%ld&page_num=%d&order=%d&order_way=%d",_cat_type,i,_order+1,_order_way+1];
        NSLog(@"%@",[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]);
        [self getDataFromService:[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]];
        i++;
    }];
    self.tableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        static int i=1;
        NSString *goods_list = [NSString stringWithFormat:@"method=goods_list&cat_type=%ld&page_num=%d&order=%d&order_way=%d",_cat_type,i,_order+1,_order_way+1];
        NSLog(@"%@",[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]);
        [self getDataFromService:[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]];
        i++;
    }];
    [self.view addSubview:_suspensionView];
    
    NSString *goods_list = [NSString stringWithFormat:@"method=goods_list&cat_type=%d&page_num=%d",0,1];
    [self getDataFromService:[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]];
}

#pragma mark 更改布局
- (void)changeLayout
{
    if(_isChangeLayout)
    {
        [_coll removeFromSuperview];
        [self.view addSubview:self.tableV];
        [self.view addSubview:_suspensionView];
    }
    else
    {
        [_tableV removeFromSuperview];
        [self.view addSubview:_coll];
        [self.view addSubview:_suspensionView];
    }
    _isChangeLayout = !_isChangeLayout;
}

#pragma mark 请求数据
- (void)getDataFromService:(NSString *)urlStr
{
    [self loadData:urlStr];
}

- (void)loadData:(NSString *)str
{
    NSLog(@"%@",str);
    NetManager *nm = [NetManager shareManager];
    [nm requestStrUrl:str withSuccessBlock:^(id data) {
        NSArray *arr = data[@"data"][@"goods_info"][@"goods_list"];
        NSMutableArray *temp = [NSMutableArray array];
        for(NSDictionary *dict in arr)
        {
            DataModel *model = [[DataModel alloc] initWithDictionary:dict error:nil];
            [temp addObject:model];
        }
        if(_isFirstLoadData)
        {
            _dataArray = temp;
            _isFirstLoadData = NO;
        }
        else
        {
            NSMutableArray *dataA = [NSMutableArray arrayWithArray:_dataArray];
            //            NSInteger count = _dataArray.count+10;
            for(int i=0;i<10;i++)
            {
                [dataA addObject:temp[i]];
            }
            _dataArray = dataA;
        }
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [_coll.mj_header endRefreshing];
            [_coll reloadData];
            [self.tableV.mj_header endRefreshing];
            [self.tableV reloadData];
            
            [_coll.mj_footer endRefreshing];
            [_coll reloadData];
            [self.tableV.mj_footer endRefreshing];
            [self.tableV reloadData];
        });
    } withFailedBlock:^(NSError *error) {
        
    }];
}

#pragma mark CollectionView布局 展示商品
- (void)createThreeBtn
{
    NSArray *btnTitle = @[@"全部",@"销量",@"价格"];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    for(int i=0;i<3;i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 30)];
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget: self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+1;
        [backView addSubview:btn];
    }
    [self.view addSubview:backView];
}

- (void)pressBtn:(UIButton *)button
{
    if([button.titleLabel.text isEqualToString:@"全部"])
    {
        [button setTitle:@"收起" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
             _suspensionView.frame = CGRectMake(0, 30, SCREEN_WIDTH/3, 90);
        }];
    }
    else if([button.titleLabel.text isEqualToString:@"销量"])
    {
        //降序排列
        //method=goods_list&cat_type=1151&page_num=1&&order=2&order_way=1
    }
    else if([button.titleLabel.text isEqualToString:@"价格"])
    {
        NSLog(@"------******__");
        _order = YES;
        NSString *goods_list = [NSString stringWithFormat:@"method=goods_list&cat_type=%ld&page_num=%d&order=%d&order_way=%d",_cat_type,1,_order+1,_order_way+1];
        [_dataArray removeAllObjects];
        NSLog(@"%@",[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]);
        [self getDataFromService:[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]];
        _order = !_order;
        _order_way = !_order_way;
    }
    else if([button.titleLabel.text isEqualToString:@"收起"])
    {
        if(_isFirst)
        {
            [button setTitle:@"全部" forState:UIControlStateNormal];
            _isFirst = NO;
        }
        else
        {
            [button setTitle:_category forState:UIControlStateNormal];
        }
        [UIView animateWithDuration:0.5 animations:^{
            _suspensionView.frame = CGRectMake(0, -90, SCREEN_WIDTH/3, 90);
        }];
    }
    else if([button.titleLabel.text isEqualToString:_category])
    {
        [UIView animateWithDuration:0.5 animations:^{
            _suspensionView.frame = CGRectMake(0, 30, SCREEN_WIDTH/3, 90);
        }];
    }
}

- (UIView *)createSuspensionView:(CGRect)frame
{
    NSArray *cate = @[@"全部",@"汽机油",@"柴机油"];
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 90)];
    for(int i=0;i<3;i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i*30, SCREEN_WIDTH/3, 30)];
        [btn setTitle:cate[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cateBtn:) forControlEvents:UIControlEventTouchUpInside];
        [vw addSubview:btn];
    }
    vw.backgroundColor = [UIColor redColor];
    return vw;
}

- (void)cateBtn:(UIButton *)btn
{
    UIButton *button = [self.view viewWithTag:1];
    [button setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    _category = btn.titleLabel.text;
    [UIView animateWithDuration:0.5 animations:^{
        _suspensionView.frame = CGRectMake(0, -90, SCREEN_WIDTH/3, 90);
    }];
    if([btn.titleLabel.text isEqualToString:@"全部"])
    {
        NSString *goods_list = [NSString stringWithFormat:@"method=goods_list&cat_type=%d&page_num=%d",0,1];
        _cat_type = 0;
        [_dataArray removeAllObjects];
        NSLog(@"%@",[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]);
        [self getDataFromService:[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]];
    }
    if([btn.titleLabel.text isEqualToString:@"汽机油"])
    {
        NSString *goods_list = [NSString stringWithFormat:@"method=goods_list&cat_type=%d&page_num=%d",1150,1];
        _cat_type = 1150;
        [_dataArray removeAllObjects];
        NSLog(@"%@",[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]);
        [self getDataFromService:[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]];
    }
    if([btn.titleLabel.text isEqualToString:@"柴机油"])
    {
        NSString *goods_list = [NSString stringWithFormat:@"method=goods_list&cat_type=%d&page_num=%d",1151,1];
        _cat_type = 1151;
        [_dataArray removeAllObjects];
        [self getDataFromService:[NSString stringWithFormat:@"%@?%@", API_SERVER,goods_list]];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = [[DataModel alloc] init];
    CVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    model = _dataArray[indexPath.item];
    [cell updateCellData:model];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-------collec");
    DataModel *model = [[DataModel alloc] init];
    model = _dataArray[indexPath.item];
    
    DetailTableView *dtv = [[DetailTableView alloc] init];
    dtv.goodsID = model.goods_id;
    [self.navigationController pushViewController:dtv animated:YES];
}


#pragma mark TableView布局 展示商品
- (UITableView *)tableV
{
    if(nil == _tableV)
    {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-143) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        
    }
    return _tableV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellID";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell)
    {
        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell = [[[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:nil options:nil] lastObject];
    DataModel *model = [[DataModel alloc] init];
    model = _dataArray[indexPath.row];
    [cell updateCellData:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = [[DataModel alloc] init];
    model = _dataArray[indexPath.row];
    
    DetailTableView *dtv = [[DetailTableView alloc] init];
    dtv.goodsID = model.goods_id;
    [self.navigationController pushViewController:dtv animated:YES];
}

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
