//
//  AppDelegate.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AppDelegate.h"
#import "BXHLaunchViewController.h"
#import "HomePageViewController.h"
#import "MessageViewController.h"
#import "PersonCenterViewController.h"
#import "WealViewController.h"

#import "EZOpenSDKHeader.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "WeiboApiManager.h"
#import "QQApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <AlipaySDK/AlipaySDK.h>


#import <BaiduMapAPI_Base/BMKMapManager.h>

#import "AppDelegate+JPushAppDelegate.h"



@interface AppDelegate () <BMKGeneralDelegate,BXHLaunchViewControllerDelegate,LoginViewControllerProtcol>

@property (nonatomic, strong) BaseNaviController *loginNav;

@property (strong, nonatomic) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:DEF_SCREENBOUNDS];

    BOOL ret = [EZOpenSDK initLibWithAppKey:@"f158ed281ffb4e8f95f55081b1b085c0"];
    if (!ret)
    {
        BXHLog(@"失败");
    }
    [EZOpenSDK enableP2P:YES];
    [EZOpenSDK setDebugLogEnable:YES];
    
    [self registJPushNotification:launchOptions];

    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    BXHLaunchViewController *vc = [[BXHLaunchViewController alloc] init];
    vc.delegate = self;
    //    [self.window makeKeyAndVisible];
    [vc show];

    self.loginViewController = [[LoginViewController alloc] init];
    self.loginViewController.protcol = self;
    self.loginNav = [[BaseNaviController alloc] initWithRootViewController:self.loginViewController];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self pushDealWithToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url scheme] isEqualToString:@"wb3049638805"])
    {
        return [WeiboSDK handleOpenURL:url delegate:[WeiboApiManager shareManager]];
    }
    else if ([[url scheme] isEqualToString:@"tencent101408905"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([[url scheme] isEqualToString:@"STAliAuth"])
    {
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:NULL];
        return YES;
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@"wb3049638805"])
    {
        return [WeiboSDK handleOpenURL:url delegate:[WeiboApiManager shareManager]];
    }
    else if ([[url scheme] isEqualToString:@"tencent101408905"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([[url scheme] isEqualToString:@"STAliAuth"])
    {
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:NULL];
        return YES;
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([[url scheme] isEqualToString:@"wb3049638805"])
    {
        return [WeiboSDK handleOpenURL:url delegate:[WeiboApiManager shareManager]];
    }
    else if ([[url scheme] isEqualToString:@"tencent101408905"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([[url scheme] isEqualToString:@"STAliAuth"])
    {
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:NULL];
        return YES;
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
}


- (void)baiduSourceInit
{
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [self.mapManager start:@"kEvErOOByhV2Bjdd1t6IUuBGqHldWO87" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //定位服务是否可用
}

- (void)weiBoSourceInit
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"3049638805"];
}


#pragma mark - launchDelegate

- (void)bxhLaunchViewControllerDidDismiss:(BXHLaunchViewController *)vc
{

}

- (void)bxhLaunchViewControllerWillDismiss:(BXHLaunchViewController *)vc
{
    [self baiduSourceInit];
    [self weiBoSourceInit];
    [QQApiManager shareInstance];
    [WXApi registerApp:@"wxedcc1ceedc97f4f3" enableMTA:YES];
    if (StringIsEmpty(KAccountInfo.userId))
    {
        [self.loginViewController show];
    }
    else
    {
        [self mainControllerShow];
    }
}

- (void)mainControllerShow
{
    self.mainTabBarController = [[BXHTabBarController alloc] init];
    self.window.rootViewController = self.mainTabBarController;
    [self.window makeKeyAndVisible];
    if (!self.mainTabBarController.controllers)
    {
        // 设置UIPageViewController的配置项
        BaseNaviController *nav1 = [[BaseNaviController alloc] initWithRootViewController:[[HomePageViewController alloc] init]];
        BaseNaviController *nav2 = [[BaseNaviController alloc] initWithRootViewController:[[WealViewController alloc] init]];
        BaseNaviController *nav3 = [[BaseNaviController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        BaseNaviController *nav4 = [[BaseNaviController alloc] initWithRootViewController:[[MessageViewController alloc] init]];
        BaseNaviController *nav5 = [[BaseNaviController alloc] initWithRootViewController:[[PersonCenterViewController alloc] init]];
        
        self.mainTabBarController.controllers = @[nav1,nav2,nav3,nav4,nav5]; 
    }
}

#pragma mark - loginProtcol
- (void)loginViewController:(LoginViewController *)viewController loginSuccess:(BOOL)success
{
    [self mainControllerShow];
}

#pragma mark - mapDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
