//
//  RegisterVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/15.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "RegisterVC.h"
#import "HZAreaPickerView.h"
#import <SMS_SDK/SMSSDK.h>
#import "NetManager.h"
#import <AFNetworking.h>

#define API_SERVER @"http://127.0.0.1/mcmp1605/data_enter.php"
#define USER_REGISTER @"method=user_register&tel=%@&pass=%@&receive=%@&province=%@&city=%@&area=%@&address=%@"

@interface RegisterVC () <UITextFieldDelegate,HZAreaPickerDatasource,HZAreaPickerDelegate>
{
    HZAreaPickerView *_picker;
}
@property (weak, nonatomic) IBOutlet UITextField *teleNum;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *passagina;
@property (weak, nonatomic) IBOutlet UITextField *contract;

@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *detailAdd;

@property (weak, nonatomic) IBOutlet UITextField *authCode;

@end

@implementation RegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = YES;
    self.address.delegate = self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.address])
    {
        [self pickAreaShow];
        return NO;
    }
    return YES;
}

- (void)pickAreaShow
{
    _picker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict withDelegate:self andDatasource:self andInitAddrArray:@[@"辽宁",@"大连",@"甘井子"]];
    self.address.text =[NSString stringWithFormat:@"辽宁 大连 甘井子"];
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
    self.address.text = [NSString stringWithFormat:@"%@ %@ %@",picker.locate.state,picker.locate.city,picker.locate.district];
}

- (NSArray *)areaPickerData:(HZAreaPickerView *)picker
{
    return [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
}

- (IBAction)getCode:(id)sender
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.teleNum.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
       if(!error)
       {
           NSLog(@"获取验证码成功");
       }
       else
       {
           NSLog(@"错误信息:%@",error);
       }
    }];
}


- (IBAction)registerUser:(id)sender
{
    [SMSSDK commitVerificationCode:self.authCode.text phoneNumber:self.teleNum.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证成功");
            
            //进行注册
            NetManager *nm = [NetManager shareManager];
            NSString *userRegister = [NSString stringWithFormat:USER_REGISTER,self.teleNum.text,self.password.text,self.contract.text,_picker.locate.state,_picker.locate.city,_picker.locate.district,self.detailAdd.text];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,userRegister];
            NSLog(@"%@",urlStr);
            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
                if([data[@"result_code"] isEqualToString:@"0"])
                {
                    NSLog(@"Success");//注册成功
                }
            } withFailedBlock:^(NSError *error) {
                
            }];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            NSLog(@"错误信息:%@",error);
        }
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
