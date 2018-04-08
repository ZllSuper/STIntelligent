//
//  AppDelegate+JPushAppDelegate.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate (JPushAppDelegate) <JPUSHRegisterDelegate>

- (void)registJPushNotification:(NSDictionary *)launchOptions;

- (void)pushDealWithToken:(NSData *)token;

@end
