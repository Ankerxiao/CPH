//
//  TabBarC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "TabBarC.h"

@interface TabBarC ()

@property (nonatomic,strong) UITabBarController *tbc;

@end

@implementation TabBarC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self initTabBar];
}

+ (id)shareTabBar
{
    static TabBarC *tabBar = nil;
    @synchronized(self) //加锁，同步锁，保护公共变量和公共资源，在同一时间，只允许一个线程访问self
    {
        if(tabBar == nil)
        {
            tabBar = [[TabBarC alloc] init];
            [tabBar initTabBar];
        }
    }
    
    return tabBar;
}

- (instancetype)init
{
    if(self = [super init])
    {
        [self initTabBar];
    }
    return self;
}

- (void)initTabBar
{
    
    NSArray *tabBarVC = @[@"HomePage",@"Goods",@"Shopping",@"MyChe"];
    NSArray *tabBarName = @[@"首页",@"全部商品",@"购物车",@"我的美车"];
    NSArray *selectedImage = @[@"tab_home",@"tab_goods",@"tab_cart",@"tab_user"];
    NSArray *unselectedImage = @[@"address_del",@"yanzheng",@"add_cart",@"yonghuming"];
    NSMutableArray *navArray = [NSMutableArray array];
    for(int i=0;i<4;i++)
    {
        Class class = NSClassFromString([NSString stringWithFormat:@"%@VC",tabBarVC[i]]);
        UIViewController *vc = [[class alloc] init];
        vc.title = tabBarName[i];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabBarName[i] image:[[UIImage imageNamed:unselectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAutomatic] selectedImage:[[UIImage imageNamed: selectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        nav.navigationBar.barStyle = UIStatusBarStyleLightContent;
        [navArray addObject:nav];
    }
    self.viewControllers = navArray;
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
