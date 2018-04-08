//
//  HomeSceneAddRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/4.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface HomeSceneAddRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *communityUserId;

@property (nonatomic, copy) NSString *sceneName;

@end
