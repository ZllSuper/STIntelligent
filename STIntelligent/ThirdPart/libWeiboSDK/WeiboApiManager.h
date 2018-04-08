//
//  WeiboApiManager.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/17.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WeiboAuthBack)(BOOL success, NSString *message, NSString *userId, NSString *nickName, NSString *headerImage);

@interface WeiboApiManager : NSObject <WeiboSDKDelegate>

+ (WeiboApiManager *)shareManager;

- (void)weiboLoginStartCallBack:(WeiboAuthBack)callBack;

- (void)weiboLogOut;

@end
