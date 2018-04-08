//
//  MaoYanModel.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/31.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "MaoYanModel.h"

@implementation MaoYanModel

- (void)keyValueToObjecDidFinish
{
    if ([self.bid isKindOfClass:[NSNumber class]])
    {
        self.bid = [(NSNumber *)self.bid stringValue];
    }
}

- (NSDictionary *)bxhReplaceKeyFormPropertyNames
{
    return @{@"bid" : @"Id"};
}

@end
