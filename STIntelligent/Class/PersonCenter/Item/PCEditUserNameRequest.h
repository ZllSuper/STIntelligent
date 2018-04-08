//
//  PCEditUserNameRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/24.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface PCEditUserNameRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *cUserId;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *HeadImg;

@end
