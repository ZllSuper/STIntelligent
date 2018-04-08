//
//  STThirdPartBindRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/5.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface STThirdPartBindRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, copy) NSString *captchadId;

@property (nonatomic, copy) NSString *captchadContent;

@property (nonatomic, copy) NSString *thirdPartyTypeId; //固定传2

@property (nonatomic, copy) NSString *thirdPartyOnlyId;

@property (nonatomic, copy) NSString *HeadImg;

@property (nonatomic, copy) NSString *NickName;

@end
