//
//  HomeDelPageManager.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/9.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomeDelPageManager.h"
#import <EquesBusiness/YKBusinessFramework.h>

@interface HomeDelPageManager() <EquesBusinessHelperProtcol>

@property (nonatomic, weak) DeveicePageModel *pageModel;

@property (nonatomic, copy) PageDeleltSuccessCallBack successCallBack;

@end

@implementation HomeDelPageManager

+ (HomeDelPageManager *)shareInstance
{
    static dispatch_once_t onceToken;
    static HomeDelPageManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[HomeDelPageManager alloc] init];
    });
    return manager;
}

- (void)delPageStartWithPageModel:(DeveicePageModel *)pageModel successCallBack:(PageDeleltSuccessCallBack)callBack
{
    self.pageModel = pageModel;
    self.successCallBack = callBack;
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_DELRESULT_METHOD];
    [self eqBusinessDelMaoYanRequest:self.pageModel.maoYanModel];
    
}

- (SheXiangTouModel *)nextCameraModel:(SheXiangTouModel *)model
{
    if ([model isEqual:self.pageModel.cameraOne])
    {
        return self.pageModel.cameraTwo;
    }
    else if ([model isEqual:self.pageModel.cameraTwo])
    {
        return self.pageModel.cameraThree;
    }
    else if ([model isEqual:self.pageModel.cameraThree])
    {
        return self.pageModel.cameraFour;
    }
    else
    {
        return nil;
    }
}

#pragma mark - request
- (void)sceneDeleteRequest
{
    HomeDeleteSceneRequest *request = [[HomeDeleteSceneRequest alloc] init];
    request.sceneId = self.pageModel.pageId;
    BXHWeakObj(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        if ([request.response.code integerValue] == 200)
        {
            selfWeak.successCallBack();
        }
        else
        {
            [selfWeak sceneDeleteRequest];
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        [selfWeak sceneDeleteRequest];
    }];
}

- (void)cameraDelRequest:(SheXiangTouModel *)model
{
    if (StringIsEmpty(model.deviceSerialNo))
    {
        SheXiangTouModel *nextModel = [self nextCameraModel:model];
        if (nextModel)
        {
            [self cameraDelRequest:nextModel];
        }
        else
        {
            [self sceneDeleteRequest];
        }
        return;
    }
    CameraDelRequest *request = [[CameraDelRequest alloc] init];
    request.deviceSerial = model.deviceSerialNo;
    request.num = @"1";
    BXHWeakObj(self);
    BXHBlockObj(model);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        if ([request.response.code integerValue] == 200)
        {
            SheXiangTouModel *nextModel = [selfWeak nextCameraModel:modelblock];
            if (nextModel)
            {
                [selfWeak cameraDelRequest:nextModel];
            }
            else
            {
                [selfWeak sceneDeleteRequest];
            }
            
            POST_NOTIFICATION(kRefreshHomePageNotification, nil);
        }
        else
        {
            [selfWeak cameraDelRequest:modelblock];
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        [selfWeak cameraDelRequest:modelblock];
    }];
}

- (void)eqBusinessDelMaoYanRequest:(MaoYanModel *)model
{
    if (StringIsEmpty(model.bid))
    {
        [self cameraDelRequest:self.pageModel.cameraOne];
        return;
    }
    [YKBusinessFramework equesDelDeviceWithBid:model.bid];
}

- (void)maoYanDelRequest:(MaoYanModel *)model
{
    MaoYanDelRequest *request = [[MaoYanDelRequest alloc] init];
    request.deviceSerial = model.bid;
    BXHWeakObj(self);
    BXHBlockObj(model);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        if ([request.response.code integerValue] == 200)
        {
            [selfWeak cameraDelRequest:selfWeak.pageModel.cameraOne];
        }
        else
        {
            [selfWeak maoYanDelRequest:modelblock];
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        [selfWeak maoYanDelRequest:modelblock];
    }];
}

#pragma mark - protcol
- (void)equesBusinessHelper:(EquesBusinessHelper *)helper messageDict:(NSDictionary *)messageDict
{
    NSString *method = messageDict[@"method"];
    if([method isEqualToString:MAOYAN_DELRESULT_METHOD])
    {
        NSNumber *code = messageDict[@"code"];
        if ([code integerValue] == 4000)
        {
            [helper removeProtcolForMethod:MAOYAN_DELRESULT_METHOD];
            [self maoYanDelRequest:self.pageModel.maoYanModel];
        }
        else
        {
            [YKBusinessFramework equesDelDeviceWithBid:self.pageModel.maoYanModel.bid];
        }
    }
}



@end
