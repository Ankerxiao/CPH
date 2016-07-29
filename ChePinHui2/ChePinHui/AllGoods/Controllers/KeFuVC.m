//
//  KeFuVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/26.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "KeFuVC.h"
#import "EMSDK.h"
#import "SessionVC.h"
#import "ChatVC.h"
#import "ChatRoomVC.h"

@interface KeFuVC ()
{
    NSString *_user;
    NSString *_password;
}

@end

@implementation KeFuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
}

- (void)initUI
{
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(100, 100, 100, 50);
    registerBtn.backgroundColor = [UIColor greenColor];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.tag = 1;
    [self.view addSubview:registerBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(100, 160, 100, 50);
    loginBtn.backgroundColor = [UIColor greenColor];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 2;
    [self.view addSubview:loginBtn];
    
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatBtn.frame = CGRectMake(100, 220, 100, 50);
    chatBtn.backgroundColor = [UIColor greenColor];
    [chatBtn setTitle:@"聊天" forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    chatBtn.tag = 3;
    [self.view addSubview:chatBtn];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(100, 280, 100, 50);
    exitBtn.backgroundColor = [UIColor greenColor];
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.tag = 4;
    [self.view addSubview:exitBtn];
    
    
}

- (void)pressBtn:(UIButton *)button
{
    switch (button.tag) {
        case 1:
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"注册" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [ac addAction:cancelA];
            
            UIAlertAction *okA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                EMError *error = [[EMClient sharedClient] registerWithUsername:ac.textFields[0].text password:ac.textFields[1].text];
                if (error == nil)
                {
                    NSLog(@"注册成功");
                }
            }];
            [ac addAction:okA];
            
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"用户名";
            }];
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"密码";
            }];
            [self presentViewController:ac animated:YES completion:^{
            }];
        }
            break;
        case 2:
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"注册" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                EMError *error = [[EMClient sharedClient] loginWithUsername:ac.textFields[0].text password:ac.textFields[1].text];
                if (!error)
                {
                    NSLog(@"登录成功");
                }
                else
                {
                    NSLog(@"登录失败");
                }
            }];
            [ac addAction:cancelA];
            
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"用户名";
            }];
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"密码";
            }];
            
            [self presentViewController:ac animated:YES completion:nil];
        }
            break;
        case 3:
        {
            ChatRoomVC *crvc = [[ChatRoomVC alloc] init];
            [self.navigationController pushViewController:crvc animated:YES];
        }
            break;
        case 4:
        {
            EMError *error = [[EMClient sharedClient] logout:YES];
            if (!error)
            {
                NSLog(@"退出成功");
            }
        }
            break;
        default:
            break;
    }
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
