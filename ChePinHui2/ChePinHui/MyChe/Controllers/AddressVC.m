//
//  AddressVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/20.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "AddressVC.h"
#import "AddressCell.h"
#import "AddEditVC.h"
#import "NetManager.h"


#define API_SERVER @"http://10.11.57.27/mcmp1605/data_enter.php"
#define GET_DEFAULT_ADDRESS @"method=get_default_address&session_id=%@"
#define GET_ALL_ADDRESS @"method=get_all_address&session_id=%@"
#define DEL_ONE_ADDRESS @"method=delete_one_address&session_id=%@&address_id=%@"
#define SET_DEFAULT_ADDRESS @"method=set_default_address&session_id=%@&address_id=%@"
#define UPDATE_ONE_ADDRESS @"method=update_one_address&session_id=%@&address_id=%@&consignee=%@&province=%@&city=%@&district=%@&address_detail=%@&zipcode=%@&mobile=%@"
#define CREATE_ONE_ADDRESS @"method=create_one_address&session_id=%@&consignee=%@&province=%@&city=%@&district=%@&address_detail=%@&zipcode=%@&mobile=%@"

@interface AddressVC () <UITableViewDelegate,UITableViewDataSource,AddressCellDelegate>
{
    NSArray *_addressArray;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation AddressVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _addressArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [self footerView];
    [_tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"cellid"];
    [self.view addSubview:_tableView];

    
}

- (void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onClk:) name:@"A" object:nil];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:GET_ALL_ADDRESS,[ud objectForKey:@"session"]];
    
    NetManager *nm = [NetManager shareManager];
    [nm requestStrUrl:[NSString stringWithFormat:@"%@?%@",API_SERVER,str] withSuccessBlock:^(id data) {
        NSLog(@"%@",data);
        _addressArray = data[@"data"][@"all_address_info"];
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tableView reloadData];
        });
//        [self updateAddressView];
    } withFailedBlock:^(NSError *error) {
        
    }];
}

- (void)updateAddressView
{
    
}

- (UIView *)footerView
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"新增" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)addAddress
{
    AddEditVC *aevc = [[AddEditVC alloc] init];
    [self.navigationController pushViewController:aevc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    cell.delegate = self;
    //拿到数据
    [cell updateContentInCell:_addressArray[indexPath.row]];
    
    
    //更新cell
//    cell update
    if(indexPath.row == 0)
    {
        //默认地址
    }
    
    return cell;
}

- (void)deleteAddress
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressArray.count;
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
