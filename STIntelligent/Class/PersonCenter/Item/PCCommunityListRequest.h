//
//  PCCommunityListRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/29.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface PCCommunityListRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *cUserId;

@property (nonatomic, copy) NSString *pageSize;

@property (nonatomic, copy) NSString *curPage;

@end
