//
//  ShoppingVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "ShoppingVC.h"
#import "LoginVC.h"
#import "NetManager.h"
#import "CartModel.h"
#import "CartCell.h"

#define SESSION_ID @"2c0e89fc3c3b91afaa46becef9a0656f"
#define API_SERVER @"http://10.11.57.27/mcmp1605/data_enter.php"
#define GET_CART_INFO @"method=get_all_cart&session_id=%@"
#define DELETE_SHOPPING @"method=cart_delete_goods&session_id=%@&goods_id=%@"

@interface ShoppingVC () <UITableViewDelegate,UITableViewDataSource,CartCellDelegate>
{
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ShoppingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-124) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CartCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
    
    [self calculatePriceOfView];
}

#pragma mark 判断是否显示登陆界面
- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([[ud objectForKey:@"Login"] isEqualToString:@"Logined"])
    {
        [self initCart];
    }
    else
    {
        LoginVC *lvc = [[LoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
        nav.navigationBar.barTintColor = [UIColor redColor];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark 初始化购物车，即是向服务器请求数据
- (void)initCart
{
    //向服务器请求数据
    [self getCartInfo];
}

- (void)getCartInfo
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:GET_CART_INFO,[ud objectForKey:@"session"]];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,str];
    NSLog(@"%@",urlStr);
    NetManager *nm = [NetManager shareManager];
    [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
        NSArray *array = data[@"data"][@"cart_list"];
        NSLog(@"%@",array);
        NSMutableArray *tempArray = [NSMutableArray array];
        for(NSDictionary *dict in array)
        {
            CartModel *model = [[CartModel alloc] initWithDictionary:dict error:nil];
            [tempArray addObject:model];
        }
        _dataArray = tempArray;
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tableView reloadData];
        });
    } withFailedBlock:^(NSError *error) {
        
    }];
}

#pragma mark 数据请求到本地之后，开始显示数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellID";
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    cell.delegate = self;
    CartModel *model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 129;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"------");
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartModel *model = _dataArray[indexPath.row];
    [_dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
    NetManager *nm = [NetManager shareManager];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:DELETE_SHOPPING,[ud objectForKey:@"session"],model.goods_id];
    [nm requestStrUrl:[NSString stringWithFormat:@"%@?%@",API_SERVER,str] withSuccessBlock:^(id data) {
        
    } withFailedBlock:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"abcd");
}


#pragma mark 底部View，用于计算被选中商品的总价格
- (void)calculatePriceOfView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-163, SCREEN_WIDTH, 60)];
    backView.backgroundColor = [UIColor grayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2, 60)];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"合计:￥0.00" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    label.attributedText = attr;
    label.tag = 10000;
//    label.textColor = [UIColor whiteColor];
    [backView addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100,0, 100, 60)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"去结算" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:btn];
    [self.view addSubview:backView];
    
}

- (void)updatePrice:(CartModel *)price
{
    float allPrice = 0;
    //计算总价格
    for(CartModel *model in _dataArray)
    {
        if([model.isSelected isEqualToString:@"1"])
        {
            allPrice += [model.goods_number integerValue]*[model.goods_price floatValue];
        }
    }
    NSLog(@"%f",allPrice);
    UILabel *label = [self.view viewWithTag:10000];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计:￥%.2f",allPrice] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    label.attributedText = attr;
}

- (void)didReceiveMemoryWarning
{
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
