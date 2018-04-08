//
//  MaoYanAddRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/31.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface MaoYanAddRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *sceneId;

@property (nonatomic, copy) NSString *deviceSerial;

@property (nonatomic, copy) NSString *name;

@end
