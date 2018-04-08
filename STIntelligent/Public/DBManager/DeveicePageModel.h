//
//  DeveicePageModel.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/31.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaoYanModel.h"
#import "SheXiangTouModel.h"

@interface DeveicePageModel : NSObject

@property (nonatomic, copy) NSString *pageId;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *defaultImage;

@property (nonatomic, assign) int defaultIndex; // 0没有 1MaoYan 2cameraOne 32cameraTwo 42cameraThree 5cameraFour

@property (nonatomic, strong) MaoYanModel *maoYanModel;

@property (nonatomic, strong) SheXiangTouModel *cameraOne;

@property (nonatomic, strong) SheXiangTouModel *cameraTwo;

@property (nonatomic, strong) SheXiangTouModel *cameraThree;

@property (nonatomic, strong) SheXiangTouModel *cameraFour;

//用于解析对应的source
@property (nonatomic, strong) NSArray *CatEyes;

@property (nonatomic, strong) NSArray *Cameras;

@end
