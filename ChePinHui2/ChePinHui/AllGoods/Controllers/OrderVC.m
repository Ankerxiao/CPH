//
//  OrderVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/21.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "OrderVC.h"
#import "NetManager.h"
#import "AddressVC.h"
#import <UIImageView+WebCache.h>
#import "OrderSuccessVC.h"
#import "GoodsListCell.h"

#define API_SERVER @"http://127.0.0.1/mcmp1605/data_enter.php"
#define GET_DEFAULT_ADDRESS @"method=get_default_address&session_id=%@"
#define SUBMIT_FORM @"method=order_submit&session_id=%@"

@interface OrderVC () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UIButton *_btn;
}
//tableView的headerView
@property (strong, nonatomic) IBOutlet UILabel *contentView;
@property (weak, nonatomic) IBOutlet UILabel *contractL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UIButton *otherAddr;

//tableView的footerView
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *tijaoOrder;

//商品列表


@property (nonatomic,strong) UITableView *tableView;
@end

@implementation OrderVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAddress) name:@"updateAddr" object:nil];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"AddressView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"header"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"footer"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [self tableFooterView];

    [self.view addSubview:_tableView];
    
    
    
    [self getDefaultAddress];
}

#pragma mark 头视图
- (void)changeAddress
{
    NetManager *nm = [NetManager shareManager];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:GET_DEFAULT_ADDRESS,[ud objectForKey:@"session"]];
    [nm requestStrUrl:[NSString stringWithFormat:@"%@?%@",API_SERVER,str] withSuccessBlock:^(id data) {
        NSDictionary *dictionary = data[@"data"][@"address_info"];
        
        //到主线程中更新地址信息，即赋值
        dispatch_async(dispatch_get_main_queue(),^{
            [self initHeaderView:dictionary];
        });

        
    } withFailedBlock:^(NSError *error) {
        
    }];

}

- (UIView*)tableHeaderView
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AddressView" owner:self options:nil];
    UIView *header = [nib firstObject];
    return header;
}

//请求数据，获取默认地址
- (void)getDefaultAddress
{
    //获取默认地址，并赋值给各个控件
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NetManager *nm = [NetManager shareManager];
    NSString *str = [NSString stringWithFormat:GET_DEFAULT_ADDRESS,[ud objectForKey:@"session"]];
    [nm requestStrUrl:[NSString stringWithFormat:@"%@?%@",API_SERVER,str] withSuccessBlock:^(id data) {
        NSLog(@"%@",data);
        NSDictionary *dictionary = data[@"data"][@"address_info"];
        
        //到主线程中更新地址信息，即赋值
        dispatch_async(dispatch_get_main_queue(),^{
            [self initHeaderView:dictionary];
        });
    } withFailedBlock:^(NSError *error) {
        
    }];
}

- (void)initHeaderView:(NSDictionary *)dictionary
{
    NSLog(@"%@",dictionary);
    NSLog(@"%@",dictionary[@"consignee"]);
    self.contractL.text = dictionary[@"consignee"];
    self.numberL.text = dictionary[@"mobile"];
    self.addressL.text = [NSString stringWithFormat:@"%@ %@ %@ %@",dictionary[@"province"],dictionary[@"city"],dictionary[@"district"],dictionary[@"address_detail"]];
    [self.contentView addSubview:self.contractL];
    [self.contentView addSubview:self.numberL];
    [self.contentView addSubview:self.addressL];
    [self.contentView addSubview:self.otherAddr];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

// 其他地址
- (IBAction)otherAddress:(id)sender
{
    AddressVC *avc = [[AddressVC alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark 尾视图
- (UIView*)tableFooterView
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OrderFooterView" owner:self options:nil];
    UIView *footer = [nib firstObject];
    if(self.purchaseNum != 0)
    {
        self.priceSumL.text = [NSString stringWithFormat:@"合计:￥%.2f",[self.price floatValue]*[self.purchaseNum integerValue]];
    }
    else
    {
        self.priceSumL.text = self.sumPrice;
    }
    [footer addSubview:self.priceSumL];
    return footer;
}

- (IBAction)pressTiJiao:(id)sender
{
    OrderSuccessVC *osvc = [[OrderSuccessVC alloc] init];
    
    [self.navigationController pushViewController:osvc animated:YES];
}

//每组的头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"商品列表";
    }
    if(section == 1)
    {
        return @"配送方式";
    }
    if(section == 2)
    {
        return @"配送物流";
    }
    if(section == 3)
    {
        return @"支付方式";
    }
    if(section == 4)
    {
        return @"留言备注";
    }
    if(section == 5)
    {
        return @"推荐人电话";
    }
    return nil;
}

#pragma mark tableView的代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *payImage = @[@"zhifubao",@"weixinzhifu",@"huodaofukuan"];
    NSArray *dictArr = @[@{@"支付宝":@"支付宝(手机版) 网站(www.alipay.com)是国内最先进的网上支付平台."},@{@"微信":@"微信支付是腾讯公司开放的支付平台,用户可以通过手机完成快速的支付流程."},@{@"货到付款":@"开通城市:全国 货到付款区域:全国"}];
    
    if(indexPath.section == 0)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"GoodsListCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
        GoodsListCell *lcell = [self.tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if(self.purchaseNum == 0)
        {
            [lcell updateDataWithCart:self.dataArr[indexPath.row]];
        }
        else
        {
            [lcell updateGoodsListDataInCell:self.gdModel andPurchaseNum:[self.purchaseNum integerValue]];
        }
        lcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return lcell;
    }
    if(indexPath.section == 1)
    {
        UITableViewCell *cell1 = [_tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(!cell1)
        {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        vw.userInteractionEnabled = YES;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH/3, 50)];
        label.text = @"货站自提";
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 10, 25, 25)];
        btn.selected = YES;
        [btn setImage:[UIImage imageNamed:@"radio_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"radio_sel"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [vw addSubview:label];
        cell1.accessoryView.userInteractionEnabled = YES;
        cell1.backgroundView = vw;
        cell1.accessoryView = btn;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
    if(indexPath.section == 2)
    {
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if(!cell2)
        {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 60)];
        label.numberOfLines = 0;
        [label setFont:[UIFont systemFontOfSize:14]];
        label.textColor = [UIColor grayColor];
        label.text = @"物流:车品荟会根据您的收货地址,选择最便宜的物流为您配送.具体金额,请与快递人员结算,祝您购物愉快.(机油每桶运费约为0.5～2.0元)";
        [vw addSubview:label];
        cell2.backgroundView = vw;
        return cell2;
    }
    if(indexPath.section == 3)
    {
        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if(!cell3)
        {
            cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell3"];
        }
        cell3.textLabel.text = [[dictArr[indexPath.row] allKeys] firstObject];
        cell3.detailTextLabel.text = [[dictArr[indexPath.row] allValues] firstObject];
        cell3.detailTextLabel.numberOfLines = 0;
        cell3.imageView.image = [UIImage imageNamed:payImage[indexPath.row]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 25, 25);
        [btn setImage:[UIImage imageNamed:@"radio_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"radio_sel"] forState:UIControlStateSelected];
        if(indexPath.row == 0)
        {
            btn.selected = YES;
            _btn = btn;
        }
        [btn addTarget:self action:@selector(stylePay:) forControlEvents:UIControlEventTouchUpInside];
        cell3.accessoryView.userInteractionEnabled = YES;
        cell3.accessoryView = btn;
        return cell3;
    }
    if(indexPath.section == 4)
    {
        UITableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if(!cell4)
        {
            cell4 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
        }
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 60)];
        tv.delegate = self;
        tv.text = @"给卖家留言";
        tv.userInteractionEnabled = YES;
        cell4.backgroundView.userInteractionEnabled = YES;
        cell4.backgroundView = tv;
        cell4.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell4;
    }
    if(indexPath.section == 5)
    {
        UITableViewCell *cell5 = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        if(!cell5)
        {
            cell5 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5"];
        }
        cell5.textLabel.text = @"请输入推荐人电话";
        [cell5.textLabel setFont:[UIFont systemFontOfSize:15]];
        return cell5;
    }
    return nil;
}

- (void)changeStatus:(UIButton *)button
{
    button.selected = !button.selected;
}

- (void)stylePay:(UIButton *)button
{
    _btn.selected = NO;
    button.selected = YES;
    _btn = button;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 111;
    }
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.dataArr.count;
    }
    if(section == 3)
    {
        return 3;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
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
