//
//  PCFeedBackRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/26.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface PCFeedBackRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *cUserId;

@property (nonatomic, copy) NSString *text;

@end
