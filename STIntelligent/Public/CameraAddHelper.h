//
//  CameraAddHelper.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/3.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeveicePageModel.h"
#import "SheXiangTouModel.h"

typedef void(^CameraAddSuccessCallBack)(SheXiangTouModel *cameraModel);

@interface CameraAddHelper : NSObject

@property (nonatomic, strong, readonly) DeveicePageModel *addPageModel;

@property (nonatomic, strong, readonly) SheXiangTouModel *addCameraModel;

+ (CameraAddHelper *)shareInstance;

- (void)startAddWithPageModel:(DeveicePageModel *)pageModel andCameraModel:(SheXiangTouModel *)cameraModel successCallBack:(CameraAddSuccessCallBack)callBack;

- (void)addEndWithSuccess:(BOOL)success;

@end
