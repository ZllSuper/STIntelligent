//
//  STThirdPartLoginRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/5.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface STThirdPartLoginRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *thirdPartyTypeId; //固定传2

@property (nonatomic, copy) NSString *thirdPartyOnlyId;

@end
