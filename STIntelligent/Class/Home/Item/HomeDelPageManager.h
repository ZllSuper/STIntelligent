//
//  HomeDelPageManager.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/9.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeveicePageModel.h"
#import "CameraDelRequest.h"
#import "MaoYanDelRequest.h"
#import "HomeDeleteSceneRequest.h"

typedef void(^PageDeleltSuccessCallBack)();
@interface HomeDelPageManager : NSObject

+ (HomeDelPageManager *)shareInstance;

- (void)delPageStartWithPageModel:(DeveicePageModel *)pageModel successCallBack:(PageDeleltSuccessCallBack)callBack;

@end
