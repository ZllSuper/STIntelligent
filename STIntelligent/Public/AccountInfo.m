//
//  AccountInfo.m
//  HangZhouSchool
//
//  Created by 步晓虎 on 16/2/29.
//  Copyright © 2016年 步晓虎. All rights reserved.
//

#import "AccountInfo.h"
#import <objc/runtime.h>

static NSString *const AESKEY = @"GUOGANGTONG";


@interface AccountInfo ()

@property (nonatomic, copy) AccountLogOutCallBack callBack;

@property (nonatomic, copy) AccountLoginCallBack loginCallBack;

@end

@implementation AccountInfo

NSString * AccountSourcePath(NSString *account)
{
   NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [NSString stringWithFormat:@"%@/%@",pathAry[0],account];
    return rootPath;
}

+ (AccountInfo *)shareInstance
{
    static dispatch_once_t onceToken;
    static AccountInfo *accountInfo;
    dispatch_once(&onceToken, ^{
        accountInfo = [[AccountInfo alloc] init];
    });
    return accountInfo;
}

- (instancetype) init
{
    if (self = [super init])
    {
//        self.userId = @"19a531288940496dbeca2d3c45adca28";
        NSString *savePath = AccountSourcePath(AESKEY);
        NSData *saveData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:savePath]];
        if (saveData)
        {
            NSData *decryptData = [saveData AES256DecryptWithKey:AESKEY];
            [self fillSourceWithDict:[decryptData jsonObject]];
        }
    }
    return self;
}

#pragma mark - public

- (void)monitorWithLogOut:(AccountLogOutCallBack)callBack
{
    self.callBack = callBack;
}

- (void)monitorWithlogin:(AccountLoginCallBack)callBack
{
    self.loginCallBack = callBack;
}

- (BOOL)saveToDisk
{
    NSString *savePath = AccountSourcePath(AESKEY);
    NSData *saveData = [self getSaveData];
    NSData *encryptData = [saveData AES256EncryptWithKey:AESKEY];
    BOOL save = [encryptData writeToFile:savePath atomically:YES];
    return save;
}

- (void)resetSourceWithDict:(NSDictionary *)dict
{
    self.userId = [NSString checkNilStrWithStr:dict[@"id"]];
//    self.cameraAccessToken = [NSString checkNilStrWithStr:dict[@"cameraAccessToken"]];
    self.name = [NSString checkNilStrWithStr:dict[@"name"]];
    self.phone = [NSString checkNilStrWithStr:dict[@"phone"]];
    self.photo = [NSString checkNilStrWithStr:dict[@"photo"]];
    if (self.loginCallBack)
    {
        self.loginCallBack();
    }
}

- (BOOL)logout
{
    NSString *savePath = AccountSourcePath(AESKEY);
    BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    if (ret)
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self clear];
    }
    
    if (self.callBack)
    {
        self.callBack();
    }
    return ret;
}

#pragma mark - private

- (NSArray *)bxhIgnoredPropertyNames
{
    return @[@"callBack",@"loginCallBack"];
}

- (void)fillSourceWithDict:(NSDictionary *)dict
{
    self.userId = [NSString checkNilStrWithStr:dict[@"userId"]];
//    self.cameraAccessToken = [NSString checkNilStrWithStr:dict[@"cameraAccessToken"]];
    self.name = [NSString checkNilStrWithStr:dict[@"name"]];
    self.phone = [NSString checkNilStrWithStr:dict[@"phone"]];
    self.photo = [NSString checkNilStrWithStr:dict[@"photo"]];
}

- (NSData *)getSaveData
{
    NSMutableDictionary *valueDict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i ++ )
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([[self bxhIgnoredPropertyNames] containsObject:propertyName])
        {
            continue;
        }
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue == nil)
        {
            propertyValue = @"";
        }
        [valueDict setObject:propertyValue forKey:propertyName];
    }
    
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:valueDict options:NSJSONWritingPrettyPrinted error:&parseError];

    return jsonData;
}

- (void)clear
{
    self.userId = @"";
    self.name = @"";
    self.phone = @"";
    self.photo = @"";
    self.cameraAccessToken = @"";
}

@end
