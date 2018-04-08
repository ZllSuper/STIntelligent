//
//  DeveicePageModel.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/31.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "DeveicePageModel.h"

@implementation DeveicePageModel
- (NSDictionary *)bxhReplaceKeyFormPropertyNames
{
    return @{@"pageId" : @"Id"};
}

- (void)keyValueToObjecDidFinish
{
    self.pageId = [(NSNumber *)self.pageId stringValue];
    if (![self.CatEyes isKindOfClass:[NSNull class]] && self.CatEyes.count > 0)
    {
        [self.maoYanModel bxhObjectWithKeyValues:self.CatEyes[0]];
    }
    
    if (![self.Cameras isKindOfClass:[NSNull class]] && self.Cameras.count > 0)
    {
        int i = 0;
        for (NSDictionary *dict in self.Cameras)
        {
            switch (i) {
                case 0:
                {
                    [self.cameraOne bxhObjectWithKeyValues:dict];
                }
                    break;
                case 1:
                {
                    [self.cameraTwo bxhObjectWithKeyValues:dict];
                }
                    break;
                case 2:
                {
                    [self.cameraThree bxhObjectWithKeyValues:dict];
                }
                    break;
                case 3:
                {
                    [self.cameraFour bxhObjectWithKeyValues:dict];
                }
                    break;

                default:
                    break;
            }
        }
    }
    
}

- (SheXiangTouModel *)cameraOne
{
    if (!_cameraOne)
    {
        _cameraOne = [[SheXiangTouModel alloc] init];
    }
    return _cameraOne;
}

- (SheXiangTouModel *)cameraTwo
{
    if (!_cameraTwo)
    {
        _cameraTwo = [[SheXiangTouModel alloc] init];
    }
    return _cameraTwo;
}

- (SheXiangTouModel *)cameraThree
{
    if (!_cameraThree)
    {
        _cameraThree = [[SheXiangTouModel alloc] init];
    }
    return _cameraThree;
}

- (SheXiangTouModel *)cameraFour
{
    if (!_cameraFour)
    {
        _cameraFour = [[SheXiangTouModel alloc] init];
    }
    return _cameraFour;
}

- (MaoYanModel *)maoYanModel
{
    if (!_maoYanModel)
    {
        _maoYanModel = [[MaoYanModel alloc] init];
    }
    return _maoYanModel;
}

@end
