//
//  HomeUpdateIconRequest.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/9.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface HomeUpdateIconRequest : BaseNeedHeaderReqeuest

@property (nonatomic, copy) NSString *deviceSerial;

@property (nonatomic, copy) NSString *icon;

@end
