//
//  STThemeManager.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STThemeColor.h"

@class STThemeManager;

@protocol STThemeManagerProtcol <NSObject>

- (void)themeChange;

@end

@interface STThemeManager : NSObject

//DefauleBundleName   MainThemeBundle

@property (nonatomic, copy, readonly) NSString *bundleName;

@property (nonatomic, strong, readonly) STThemeColor *themeColor;

+ (STThemeManager *)shareInstance;

- (void)addThemeChangeProtcol:(id <STThemeManagerProtcol>)protcol;

- (BOOL)changeBundleName:(NSString *)bundleName;

- (NSString *)imagePathWithName:(NSString *)name;

- (UIImage *)imageWithImageName:(NSString *)name;

@end
