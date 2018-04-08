//
//  BXHTabBarController.m
//  HangZhouSchool
//
//  Created by 步晓虎 on 16/6/1.
//  Copyright © 2016年 步晓虎. All rights reserved.
//

#import "BXHTabBarController.h"
#import "BXHBasicAnimation.h"
#import "UIView+AnimtateView.h"
#import "OpenDoorContentView.h"

@interface BXHTabBarController() <BXHTabBarDelegate, STThemeManagerProtcol>

@property (nonatomic, strong) BXHTabBar *myTabBar;

@property (nonatomic, strong) UIViewController *currentVc;

@property (nonatomic, strong) MASConstraint *animateConstraint;

@property (nonatomic, weak) OpenDoorContentView *contentView;

@end

@implementation BXHTabBarController

- (instancetype) init
{
    if (self = [super init])
    {
        
        self.view.backgroundColor = [UIColor blackColor];
        self.myTabBar = [[BXHTabBar alloc] initWithFrame:CGRectZero];
        self.myTabBar.delelgate = self;
        [self tabBarItemCreat];
        [self.view addSubview:self.myTabBar];
        [self.myTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            self.animateConstraint = make.bottom.mas_equalTo(self.view).offset(0);
            make.height.mas_equalTo(TabBarHeight);
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[STThemeManager shareInstance] addThemeChangeProtcol:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)setTabBarHidden:(BOOL)hidden animate:(BOOL)animate
{
    CGFloat offset = hidden ? TabBarHeight : 0;
    if (animate)
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.animateConstraint.offset = offset;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished)
            {
                self.tabBar.hidden = hidden;
            }
        }];
    }
    else
    {
        self.animateConstraint.offset = offset;
        [self.view layoutIfNeeded];
        self.tabBar.hidden = hidden;
    }
}

- (void)setSelectControllerAtIndex:(NSInteger)index
{
    [self.tabBar setItemSelectAtIndex:index];
}

- (void)tabBarItemCreat
{
    BXHTabBarItem *item1 = [self itemCreatTitle:@"首页" normalImageName:@"TabBarNormal1" selectImageName:@"TabBarSel1"];
    BXHTabBarItem *item2 = [self itemCreatTitle:@"福利" normalImageName:@"TabBarNormal2" selectImageName:@"TabBarSel2"];
    BXHTabBarItem *item3 = [[BXHTabBarItem alloc] initWithItemType:BXHTabBarItemImageType];
    [item3 setImageName:@"TabBarNormal3" forState:NO];
    [item3 setImageName:@"TabBarSel3" forState:YES];
    [item3 setBackImage:ThemeImageWithName(@"TabBarItemBack3") backImage:ThemeImageWithName(@"TabBarItemBackImg3")];
    BXHTabBarItem *item4 = [self itemCreatTitle:@"消息" normalImageName:@"TabBarNormal4"selectImageName:@"TabBarSel4"];
    BXHTabBarItem *item5 = [self itemCreatTitle:@"我的" normalImageName:@"TabBarNormal5" selectImageName:@"TabBarSel5"];

    self.tabBar.items = @[item1,item2,item3,item4,item5];
}

- (BXHTabBarItem *)itemCreatTitle:(NSString *)title normalImageName:(NSString *)normalImageName selectImageName:(NSString *)selectImageName
{
    BXHTabBarItem *item = [[BXHTabBarItem alloc] initWithItemType:BXHTabBarItemTitleAndImageType];
    item.titleText = title;
    [item setImageName:normalImageName forState:NO];
    [item setImageName:selectImageName forState:YES];
    return item;
}

#pragma mark - tabBarDelegate
- (void)themeChange
{
    BXHTabBarItem *item3 = self.tabBar.items[2];
    [item3 setBackImage:ThemeImageWithName(@"TabBarItemBack3") backImage:ThemeImageWithName(@"TabBarItemBackImg3")];
}

- (BOOL)tabBar:(BXHTabBar *)tabBar selectItemAtIndex:(NSInteger)index
{
    BXHTabBarItem *item = tabBar.items[index];

//    if (index == 0 || index == 1 || index == 2)
//    {
//        
//    }
//    else
//    {
//        if (![self checkIsLogin])
//        {
//            return NO;
//        }
//    }
    if (index == 2)
    {
        item.selected = !item.selected;
        if (!self.contentView)
        {
            OpenDoorContentView *view = [[OpenDoorContentView alloc] init];
            [view showFromTabBarController];
            self.contentView = view;
        }
        else
        {
            [self.contentView removeFromSuperview];
        }
        return NO;
    }
    if (self.contentView)
    {
        [self.contentView removeFromSuperview];
    }
    if (item.selected)
    {
        return NO;
    }
   
    NSInteger fromIndex = [self.controllers indexOfObject:self.currentVc];
    UIViewController *showVc = self.controllers[index];
    
    if (![self.view.subviews containsObject:showVc.view])
    {
        [self addSubControllerView:showVc];
    }
    
    [self.currentVc.view.layer removeAllAnimations];
    [showVc.view.layer removeAllAnimations];
    
    [self view:self.currentVc.view show:NO fromLeft:fromIndex < index];
    [self view:showVc.view show:YES fromLeft:fromIndex > index];
    
    self.currentVc = showVc;
    
    
    
    return YES;
}

#define AnimateDur 0.3
- (void)view:(UIView *)animateView show:(BOOL)show fromLeft:(BOOL)fLeft
{
    
    if (show)
    {
        animateView.needRemoveFromSuperView = NO;
        if (fLeft)
        {
            CABasicAnimation *animate1 = [BXHBasicAnimation moveX:AnimateDur X:@0 fromx:[NSNumber numberWithFloat:-DEF_SCREENWIDTH]];
            CABasicAnimation *animate2 = [BXHBasicAnimation opacityForever_Animation:AnimateDur fromValue:@0 toValue:@1];
            CABasicAnimation *animate3 = [BXHBasicAnimation scale:@1.0 orgin:@0.5 durTimes:AnimateDur Rep:0];
            CAAnimationGroup *groupAnimate = [BXHBasicAnimation groupAnimation:@[animate1,animate2,animate3] durTimes:AnimateDur Rep:0];
            groupAnimate.delegate = animateView;
            [animateView.layer addAnimation:groupAnimate forKey:@"GroupAnimate"];
        }
        else
        {
            CABasicAnimation *animate1 = [BXHBasicAnimation moveX:AnimateDur X:@0 fromx:[NSNumber numberWithFloat:DEF_SCREENWIDTH]];
            CABasicAnimation *animate2 = [BXHBasicAnimation opacityForever_Animation:AnimateDur fromValue:@0 toValue:@1];
            CABasicAnimation *animate3 = [BXHBasicAnimation scale:@1.0 orgin:@0.5 durTimes:AnimateDur Rep:0];
            CAAnimationGroup *groupAnimate = [BXHBasicAnimation groupAnimation:@[animate1,animate2,animate3] durTimes:AnimateDur Rep:0];
            groupAnimate.delegate = animateView;
            [animateView.layer addAnimation:groupAnimate forKey:@"GroupAnimate"];
        }
    }
    else
    {
        animateView.needRemoveFromSuperView = YES;
        if (fLeft)
        {
            CABasicAnimation *animate1 = [BXHBasicAnimation moveX:AnimateDur X:[NSNumber numberWithFloat:-DEF_SCREENWIDTH] fromx:@0];
            CABasicAnimation *animate2 = [BXHBasicAnimation opacityForever_Animation:AnimateDur fromValue:@1 toValue:@0];
            CABasicAnimation *animate3 = [BXHBasicAnimation scale:@0.5 orgin:@1.0 durTimes:AnimateDur Rep:0];
            CAAnimationGroup *groupAnimate = [BXHBasicAnimation groupAnimation:@[animate1,animate2,animate3] durTimes:AnimateDur Rep:0];
            groupAnimate.delegate = animateView;
            [animateView.layer addAnimation:groupAnimate forKey:@"GroupAnimate"];
            
        }
        else
        {
            CABasicAnimation *animate1 = [BXHBasicAnimation moveX:AnimateDur X:[NSNumber numberWithFloat:DEF_SCREENWIDTH] fromx:@0];
            CABasicAnimation *animate2 = [BXHBasicAnimation opacityForever_Animation:AnimateDur fromValue:@1 toValue:@0];
            CABasicAnimation *animate3 = [BXHBasicAnimation scale:@0.5 orgin:@1.0 durTimes:AnimateDur Rep:0];
            CAAnimationGroup *groupAnimate = [BXHBasicAnimation groupAnimation:@[animate1,animate2,animate3] durTimes:AnimateDur Rep:0];
            groupAnimate.delegate = animateView;
            [animateView.layer addAnimation:groupAnimate forKey:@"GroupAnimate"];
        }
    }
}


- (void)addSubControllerView:(UIViewController *)subController
{
    [self.view insertSubview:subController.view belowSubview:self.myTabBar];
    [subController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.myTabBar.mas_top);
    }];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - get / set
- (BXHTabBar *)tabBar
{
    return self.myTabBar;
}

- (void)setControllers:(NSArray *)controllers
{
    for (UIViewController *controller in controllers)
    {
        if ([controllers indexOfObject:controller] == 0)
        {
            self.currentVc = controller;
            [self addSubControllerView:controller];
        }
       
        [self addChildViewController:controller];
    }
    _controllers = controllers;
}

@end
