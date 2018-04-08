//
//  STGetCodeRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface STGetCodeRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *phoneNumber;

@end
