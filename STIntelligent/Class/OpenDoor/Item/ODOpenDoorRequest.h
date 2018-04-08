//
//  ODOpenDoorRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/13.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface ODOpenDoorRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *cUserId; //用户id

@property (nonatomic, copy) NSString *doorId;//门id

@property (nonatomic, copy) NSString *locationX; //经度

@property (nonatomic, copy) NSString *locationY; //纬度

@end
