//
//  AlarmMessageListRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/24.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface AlarmMessageListRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *cUserId;

@property (nonatomic, copy) NSString *pageStart;

@property (nonatomic, copy) NSString *pageSize;

@end
