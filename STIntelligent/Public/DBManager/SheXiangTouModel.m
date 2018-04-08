//
//  SheXiangTouModel.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/1.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "SheXiangTouModel.h"

@implementation SheXiangTouModel

- (NSDictionary *)bxhReplaceKeyFormPropertyNames
{
    return @{@"deviceSerialNo" : @"Id",@"deviceVerifyCode" : @"Captcha"};
}

@end
