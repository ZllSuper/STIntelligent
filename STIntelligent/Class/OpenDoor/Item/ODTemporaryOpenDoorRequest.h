//
//  ODTemporaryOpenDoorRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface ODTemporaryOpenDoorRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *cUserId; //用户id

@property (nonatomic, copy) NSString *name;//被邀请人姓名

@property (nonatomic, copy) NSString *peopleType;//被邀请人类型

@property (nonatomic, copy) NSString *doorIds; //门id列表，格式“1;2;”

@end
