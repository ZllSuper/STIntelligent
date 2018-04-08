//
//  CameraAddRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/1.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface CameraAddRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *sceneId;

@property (nonatomic, copy) NSString *deviceSerial;

@property (nonatomic, copy) NSString *vCode;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *imageId;

@end
