//
//  AddEditVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/20.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "AddEditVC.h"
#import "HZAreaPickerView.h"
#import "NetManager.h"

#define API_SERVER @"http://127.0.0.1/mcmp1605/data_enter.php"
#define CREATE_ONE_ADDRESS @"method=create_one_address&session_id=%@&consignee=%@&province=%@&city=%@&district=%@&address_detail=%@&zipcode=%@&mobile=%@"
#define UPDATE_ONE_ADDRESS @"method=update_one_address&session_id=%@&address_id=%@&consignee=%@&province=%@&city=%@&district=%@&address_detail=%@&zipcode=%@&mobile=%@"

@interface AddEditVC () <UITextFieldDelegate,HZAreaPickerDatasource,HZAreaPickerDelegate>
{
    HZAreaPickerView *_picker;
}
@property (nonatomic,copy) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UITextField *contract;
@property (weak, nonatomic) IBOutlet UITextField *num;
@property (weak, nonatomic) IBOutlet UITextField *area;
@property (weak, nonatomic) IBOutlet UITextField *detailAdd;
@property (weak, nonatomic) IBOutlet UITextField *code;

@end

@implementation AddEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.area.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contract.text = _dict[@"consignee"];
    self.num.text = _dict[@"mobile"];
    self.detailAdd.text = _dict[@"address_detail"];
    self.code.text = _dict[@"zipcode"];
    //    HZAreaPickerView *pick = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict withDelegate:self andDatasource:self andInitAddrArray:@[dict[@"province"],dict[@"city"],dict[@"district"]]];
    self.area.text = [NSString stringWithFormat:@"%@ %@ %@",_dict[@"province"],_dict[@"city"],_dict[@"district"]];
}

- (void)updateInfo:(NSDictionary *)dict
{
    _dict = [NSDictionary dictionary];
    _dict = dict;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.area])
    {
        [self pickAreaShow];
        return NO;
    }
    return YES;
}

- (void)pickAreaShow
{
    _picker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict withDelegate:self andDatasource:self andInitAddrArray:@[@"安徽",@"六安",@"寿县"]];
    self.area.text =[NSString stringWithFormat:@"安徽 六安 寿县"];
    [_picker setBackgroundColor:[UIColor redColor]];
    [_picker showInView:self.view];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_picker cancelPicker];
}

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    NSLog(@"%@ %@ %@",picker.locate.state,picker.locate.city,picker.locate.district);
    self.area.text = [NSString stringWithFormat:@"%@ %@ %@",picker.locate.state,picker.locate.city,picker.locate.district];
}

- (NSArray *)areaPickerData:(HZAreaPickerView *)picker
{
    return [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
}



- (IBAction)saveBtn:(id)sender
{
//    &consignee=%@&province=%@&city=%@&district=%@&address_detail=%@&zipcode=%@&mobile=%@"
    if(_dict != nil) //说明是编辑状态
    {
        NSLog(@"%@ %@ %@ %@ %@",self.contract.text,self.num.text,self.area.text,self.detailAdd.text,self.code.text);
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *array = [self.area.text componentsSeparatedByString:@" "];
        NSString *str = [NSString stringWithFormat:UPDATE_ONE_ADDRESS,[ud objectForKey:@"session"],_dict[@"address_id"],self.contract.text,array[0],array[1],array.count==3?array[2]:@"",self.detailAdd.text,self.code.text,self.num.text];
        NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,str];
        NetManager *nm = [NetManager shareManager];
        [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [ac addAction:cancel];
                [self presentViewController:ac animated:YES completion:nil];
            });
        } withFailedBlock:^(NSError *error) {
            
        }];
        return;
    }
    NSLog(@"%@ %@ %@ %@ %@",self.contract.text,self.num.text,self.area.text,self.detailAdd.text,self.code.text);
    NSArray *array = [self.area.text componentsSeparatedByString:@" "];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:CREATE_ONE_ADDRESS,[ud objectForKey:@"session"],self.contract.text,array[0],array[1],array.count==3?array[2]:@"",self.detailAdd.text,self.code.text,self.num.text];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,str];
    NSLog(@"%@",urlStr);
    NetManager *nm = [NetManager shareManager];
    [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
        dispatch_async(dispatch_get_main_queue(),^{
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:cancel];
            [self presentViewController:ac animated:YES completion:nil];
             });
    } withFailedBlock:^(NSError *error) {
        
    }];
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
