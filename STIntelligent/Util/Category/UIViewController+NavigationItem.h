//
//  UIViewController+NavigationItem.h
//  TableView
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 Evan.Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationItem)
- (void)initNavigationTitleView:(UIView *(^)(void))customView;

- (void)initLeftNavigationItemWithTitle:(NSString *)title
                                 target:(id)target
                                 action:(SEL)action;


- (void)initLeftNavigationItemWithImage:(UIImage *)image
                                 target:(id)target
                                 action:(SEL)action;

- (void)initRightNavigationItemWithTitle:(NSString *)title
                                  target:(id)target
                                  action:(SEL)action;

- (UIButton *)creatLeftNavigationItemWithImage:(UIImage *)image
                                        target:(id)target
                                        action:(SEL)action;

- (UIButton *)creatRightNavigationItemWithImage:(UIImage *)image
                                  target:(id)target
                                  action:(SEL)action;

- (void)initLeftNavigationItemWithCustomButton:(void(^)(UIButton * btn))customButton;
- (void)initRightNavigationItemWithCustomButton:(void(^)(UIButton * btn))customButton;

- (void)initLeftNavigationItemWithCustomView:(void(^)(UIView * superView))customView;
- (void)initRightNavigationItemWithCustomView:(void(^)(UIView * superView))customView;

@end
