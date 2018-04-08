//
//  PCCommunitySearchRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/29.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface PCCommunitySearchRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *keyWord; //关键字

@property (nonatomic, copy) NSString *cUserId; //用户id

@property (nonatomic, copy) NSString *pageSize; //单页数量

@property (nonatomic, copy) NSString *curPage; //当前页码

@end
