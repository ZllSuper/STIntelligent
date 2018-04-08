//
//  LoginViewController.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/18.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerProtcol <NSObject>

- (void)loginViewController:(LoginViewController *)viewController loginSuccess:(BOOL)success;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, weak) id <LoginViewControllerProtcol>protcol;

@property (nonatomic, copy) NSString *onlyId;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *headerImage;

@property (nonatomic, assign) BOOL flag;//0 正常登陆页  1 没有第三方登录

- (void)show;

@end
