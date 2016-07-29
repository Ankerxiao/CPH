//
//  DetailTableView.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/14.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "DetailTableView.h"
#import "DetailCell.h"
#import "SupplierModel.h"
#import "NetManager.h"
#import "GoodsDetailVC.h"

#define API_SERVER @"http://127.0.0.1/mcmp1605/data_enter.php"
#define GET_SUPPLIER_LIST @"method=supplier_list&goods_id=%@&page_num=1" //供货商接口

@interface DetailTableView () <UITableViewDelegate,UITableViewDataSource,DetailCellDelegate>
{
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) UITableView *tableV;
@end

@implementation DetailTableView

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    //创建标题view
    [self createViewOne];
    
    //创建tableView
    [self.view addSubview:self.tableV];
    
    //请求数据
    NSString *goodid = [NSString stringWithFormat:GET_SUPPLIER_LIST,self.goodsID];
    NSString *str = [NSString stringWithFormat:@"%@?%@",API_SERVER,goodid];
    [self receiveDataFromServer:str];
}

#pragma mark 请求网络数据
- (void)receiveDataFromServer:(NSString *)urlStr
{
    NetManager *nm = [NetManager shareManager];
    [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
        NSArray *tempArray = data[@"data"][@"suppliers_list"];
        NSMutableArray *modelArray = [NSMutableArray array];
        for(NSDictionary *dict in tempArray)
        {
            
            SupplierModel *model = [[SupplierModel alloc] initWithDictionary:dict error:nil];
            [modelArray addObject:model];
        }
        _dataArray = modelArray;
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tableV reloadData];
        });
    } withFailedBlock:^(NSError *error) {
        
    }];
}

#pragma mark 创建标题view
- (void)createViewOne
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    NSArray *labelText = @[@"商品信息",@"出货地/配送信息",@"最低报价"];
    for(int i=0;i<3;i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 40)];
        label.text = labelText[i];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [backView addSubview:label];
    }
    backView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:backView];
}

#pragma mark 创建tableView
- (UITableView *)tableV
{
    if(nil == _tableV)
    {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [_tableV registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    }
    return _tableV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellID";
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    cell.delegate = self;
    SupplierModel *model = [[SupplierModel alloc] init];
    model = _dataArray[indexPath.row];
    [cell updateCellData:model];
    return cell;
}

- (void)presentVC:(UITableViewCell *)dcell andVC:(UIViewController *)vc
{
    GoodsDetailVC *goodsDetailVC = (GoodsDetailVC *)vc;
    goodsDetailVC.goodsID = self.goodsID;
    NSLog(@"%@",goodsDetailVC.goodsID);
    [self pushGoodsDetail:vc];
}

- (void)pushGoodsDetail:(UIViewController *)vc
{
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GoodsDetailVC *vc = [[GoodsDetailVC alloc] init];
    vc.goodsID = self.goodsID;
    [self pushGoodsDetail:vc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

@end
