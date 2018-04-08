//
//  CameraAddHelper.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/3.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "CameraAddHelper.h"

@interface CameraAddHelper()

@property (nonatomic, copy) CameraAddSuccessCallBack callBack;

@end

@implementation CameraAddHelper

+ (CameraAddHelper *)shareInstance
{
    static dispatch_once_t onceToken;
    static CameraAddHelper *helper;
    dispatch_once(&onceToken, ^{
        helper = [[CameraAddHelper alloc] init];
    });
    return helper;
}

- (void)startAddWithPageModel:(DeveicePageModel *)pageModel andCameraModel:(SheXiangTouModel *)cameraModel successCallBack:(CameraAddSuccessCallBack)callBack
{
    _callBack = callBack;
    _addPageModel = [[DeveicePageModel alloc] init];
    _addPageModel.pageId = pageModel.pageId;
    
    _addCameraModel = [[SheXiangTouModel alloc] init];
}

- (void)addEndWithSuccess:(BOOL)success
{
    if (success)
    {
        self.callBack(_addCameraModel);
    }
    _addPageModel = nil;
    _addCameraModel = nil;
}


@end
