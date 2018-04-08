//
//  PCCommunityModel.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/29.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"

@interface PCCommunityModel : BaseNeedHeaderReqeuest

@property (nonatomic, strong) NSNumber *communtyId;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, strong) NSNumber *State;

@property (nonatomic, copy) NSString *Introduce;

@property (nonatomic, copy) NSString *ImgUrl;

@end
