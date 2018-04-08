//
//  HomeSceneEditNameRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/4.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface HomeSceneEditNameRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *sceneId;

@property (nonatomic, copy) NSString * name;

@end
