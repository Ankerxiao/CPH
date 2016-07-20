//
//  MyCheVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "MyCheVC.h"
#import "LoginVC.h"
#import "TabBarC.h"
#import "MyCollectionVC.h"
#import "AddressVC.h"

@interface MyCheVC () <LoginVCDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    
}
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MyCheVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];

    
    NSArray *array = @[@[@"我的资产"],
                       @[@"我的积分  我的红包"],
                       @[@"待收货 待发货 待付款 待评价"],
                       @[@"我的订单",@"我的大批发"],
                       @[@"收货地址",@"意见反馈",@"设置"],
                       @[@"客户电话:400-643-7868"]];
    _dataArray = [NSMutableArray arrayWithArray:array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-113) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self tableViewHeaderView];

}

#pragma mark 区分登录和未登录
- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([[ud objectForKey:@"Login"] isEqualToString:@"Logined"])
    {
        [self initSubViews];
    }
    else
    {
        for(UIView *vw in self.view.subviews)
        {
            [vw removeFromSuperview];
        }
        [self presentLogin];
    }
}

- (void)presentLogin
{
    LoginVC *lvc = [[LoginVC alloc] init];
    lvc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
    nav.navigationBar.barTintColor = [UIColor redColor];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)passValue:(BOOL)boolean
{
    self.isFirst = boolean;
}

#pragma mark 登陆成功之后或已登录的界面
//tableView的头视图
- (UIView *)tableViewHeaderView
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    vw.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 50)];
    label.text = [ud objectForKey:@"telNum"];
    [vw addSubview:label];
    return vw;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rightTitle = @[@[@"查看全部订单",@"订单列表"],
                            @[@"编辑",@"给我留言",@""]];
    static NSString *str = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    if(indexPath.section == 3 || indexPath.section == 4)
    {
        cell.detailTextLabel.text = rightTitle[indexPath.section-3][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 4 && indexPath.row == 0)
    {
        AddressVC *avc = [[AddressVC alloc] init];
        [self.navigationController pushViewController:avc animated:YES];
    }
}

- (void)initSubViews
{
    [self.view addSubview:_tableView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 200, 20)];
    label.text = @"登录成功";
    label.textColor = [UIColor purpleColor];
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(120, 300, 100, 50)];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    //收藏按钮
    UIButton *collecBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    [collecBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
    [collecBtn addTarget:self action:@selector(pressCollecBtn) forControlEvents:UIControlEventTouchUpInside];
    collecBtn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:collecBtn];
}

- (void)pressBtn
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"unLogin" forKey:@"Login"];
    [ud setInteger:0 forKey:@"selected"];
    [ud synchronize];
    TabBarC *tabBar = [TabBarC shareTabBar];
    tabBar.selectedIndex = 0;
}

- (void)pressCollecBtn
{
    MyCollectionVC *vc = [[MyCollectionVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
