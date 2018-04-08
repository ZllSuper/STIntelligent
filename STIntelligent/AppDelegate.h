//
//  AppDelegate.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHTabBarController.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) BXHTabBarController *mainTabBarController;

@property (nonatomic, strong) LoginViewController *loginViewController;

@end

