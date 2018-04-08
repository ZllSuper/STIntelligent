//
//  STTokenLoginRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface STTokenLoginRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *phoneNumber; //手机号码

@property (nonatomic, copy) NSString *captchad; //验证码

@property (nonatomic, copy) NSString *captchadId;//验证码id

@end
