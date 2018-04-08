//
//  PCLogoutRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface PCLogoutRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *cUserId;

@end
