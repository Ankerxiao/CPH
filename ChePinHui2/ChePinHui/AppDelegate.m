//
//  AppDelegate.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/11.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarC.h"

#import <SMS_SDK/SMSSDK.h>

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    TabBarC *tbc = [TabBarC shareTabBar];
//    tbc = [[TabBarC alloc] init];
//    [tbc init];
    tbc.delegate = self;
    tbc.selectedIndex = [ud integerForKey:@"selected"];
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //短信验证码
    [SMSSDK registerApp:@"14f7ec0014118" withSecret:@"a2e246fa2136fab8ac2538fcffc48c16"];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:tabBarController.selectedIndex forKey:@"selected"];
    [ud synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
