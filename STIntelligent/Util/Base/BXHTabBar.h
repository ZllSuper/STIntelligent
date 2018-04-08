//
//  BXHTabBar.h
//  HangZhouSchool
//
//  Created by 步晓虎 on 16/6/1.
//  Copyright © 2016年 步晓虎. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BXHTabBarItemType) {
    BXHTabBarItemImageType,
    BXHTabBarItemTitleAndImageType
};

@interface BXHTabBarItem : UIControl<STThemeManagerProtcol>

@property (nonatomic, readonly) BXHTabBarItemType itemType;

- (instancetype)initWithItemType:(BXHTabBarItemType)itemType;

- (void)setImageName:(NSString *)imageName forState:(BOOL)selected;

- (void)setBackImage:(UIImage *)image backImage:(UIImage *)backImage;

@property (nonatomic, copy) NSString *titleText;

@end

#define TabBarHeight 48.0

#define ItemGap 0.0

@class BXHTabBar;

@protocol BXHTabBarDelegate <NSObject>

- (BOOL)tabBar:(BXHTabBar *)tabBar selectItemAtIndex:(NSInteger)index;

@end

@interface BXHTabBar : UIView <STThemeManagerProtcol>

@property (nonatomic, strong) UIImageView *backgroundImageView0;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSArray <BXHTabBarItem *>*items;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, weak) id <BXHTabBarDelegate> delelgate;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) UIBezierPath *tabBarPath;


- (void)setItemSelectAtIndex:(NSInteger)index;

@end
