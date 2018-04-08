//
//  PCAddCommunityRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/29.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface PCAddCommunityRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *cUserId; //用户id

@property (nonatomic, copy) NSString *communityId; //社区id

@property (nonatomic, copy) NSString *floorId; //楼栋id

@end
