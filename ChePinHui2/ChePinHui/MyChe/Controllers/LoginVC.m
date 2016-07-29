//
//  LoginVC.m
//  
//
//  Created by Anker Xiao on 16/7/15.
//
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "NetManager.h"
#import "MyCheVC.h"

#define API_SERVER @"http://127.0.0.1/mcmp1605/data_enter.php"
#define USER_LOGIN @"method=user_login&tel=%@&pass=%@"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *telNum;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(pressLeft)];
    self.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.telNum.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_tel"]];
    self.telNum.leftViewMode = UITextFieldViewModeAlways;
    self.password.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pass"]];
    self.password.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)pressLeft
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginBtn:(id)sender
{
    NSString *loginStr = [NSString stringWithFormat:USER_LOGIN,self.telNum.text,self.password.text];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,loginStr];
    NetManager *nm = [NetManager shareManager];
    NSLog(@"%@",urlStr);
    [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
        if([data[@"result_code"] isEqualToString:@"0"])
        {
            NSLog(@"Success");//登录成功
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:@"Logined" forKey:@"Login"];
            [ud setObject:[NSString stringWithFormat:@"%@",data[@"data"][@"session_id"]] forKey:@"session"];
            [ud setObject:self.telNum.text forKey:@"telNum"];
            [ud synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            if([_delegate respondsToSelector:@selector(showWhichVC)])
            {
                [_delegate showWhichVC];
            }
            
        }
        else
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的用户名和密码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:cancel];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
    } withFailedBlock:^(NSError *error) {
        
    }];

}

- (IBAction)registerBtn:(id)sender
{
    RegisterVC *rvc = [[RegisterVC alloc] init];
    rvc.title = @"用户注册";
    [self.navigationController pushViewController:rvc animated:YES];
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
