//
//  AccountInfo.h
//  HangZhouSchool
//
//  Created by 步晓虎 on 16/2/29.
//  Copyright © 2016年 步晓虎. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KAccountInfo  ([AccountInfo shareInstance])

typedef void(^AccountLogOutCallBack)();

typedef void(^AccountLoginCallBack)();

@interface AccountInfo : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *cameraAccessToken;

@property (nonatomic, copy) NSString *jpushId;


+ (AccountInfo *)shareInstance;

- (BOOL)saveToDisk;

- (void)resetSourceWithDict:(NSDictionary *)dict;

- (BOOL)logout;

- (void)monitorWithLogOut:(AccountLogOutCallBack)callBack;

- (void)monitorWithlogin:(AccountLoginCallBack)callBack;


@end
