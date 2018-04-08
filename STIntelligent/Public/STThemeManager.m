//
//  STThemeManager.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "STThemeManager.h"

#define STCaCheThemeBundle @"STCaCheThemeBundle"

@interface STThemeManager()

@property (nonatomic, strong) NSBundle *themeBundle;

@property (nonatomic, copy) NSString *imageSuffix;

@property (nonatomic, strong) NSHashTable *protcolTable;

@end

@implementation STThemeManager

+ (STThemeManager *)shareInstance
{
    static dispatch_once_t onceToken;
    static STThemeManager *themeManager;
    dispatch_once(&onceToken, ^{
        themeManager = [[STThemeManager alloc] init];
    });
    return themeManager;
}

- (instancetype) init
{
    if (self = [super init])
    {
    
        self.protcolTable = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
        
        NSString *cacheBundle = [[NSUserDefaults standardUserDefaults] objectForKey:STCaCheThemeBundle];
        [self privateChangeBundleName:StringIsEmpty(cacheBundle) ? @"MainThemeBundle" : cacheBundle];
        
        CGFloat scale = [UIScreen mainScreen].scale;
        if (scale >= 3)
        {
            self.imageSuffix = @"@3x";
        }
        else
        {
            self.imageSuffix = @"@2x";
        }
    }
    return self;
}

#pragma mark - public

- (void)addThemeChangeProtcol:(id<STThemeManagerProtcol>)protcol
{
    if (![self.protcolTable containsObject:protcol])
    {
        [self.protcolTable addObject:protcol];
    }
}

- (BOOL)changeBundleName:(NSString *)bundleName
{
    if ([self privateChangeBundleName:bundleName])
    {
        [[NSUserDefaults standardUserDefaults] setObject:bundleName forKey:STCaCheThemeBundle];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (id <STThemeManagerProtcol>protcol in self.protcolTable)
        {
            [protcol themeChange];
        }
        return YES;
    }
    return NO;
}

- (NSString *)imagePathWithName:(NSString *)name
{
    return [self.themeBundle pathForResource:[NSString stringWithFormat:@"%@%@",name,self.imageSuffix] ofType:@"png"];
}

- (UIImage *)imageWithImageName:(NSString *)name
{
    NSString *path = [self imagePathWithName:name];
    if (StringIsEmpty(path))
    {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:path];
}

#pragma mark - private
- (BOOL)privateChangeBundleName:(NSString *)bundleName
{
    _bundleName = bundleName;
    NSString *path = [[NSBundle mainBundle] pathForResource:_bundleName ofType:@"bundle"];
    if (StringIsEmpty(path))
    {
        return NO;
    }
    self.themeBundle = [NSBundle bundleWithPath:path];
    NSString *plistPath = [self.themeBundle pathForResource:@"ThemeColor" ofType:@"plist"];
    NSDictionary *themeDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    _themeColor = [STThemeColor bxhObjectWithKeyValues:themeDict];
    return YES;

}

@end
