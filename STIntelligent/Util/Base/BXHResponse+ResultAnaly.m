//
//  BXHResponse+ResultAnaly.m
//  GuoGangTong
//
//  Created by 步晓虎 on 2016/12/12.
//  Copyright © 2016年 woshishui. All rights reserved.
//

#import "BXHResponse+ResultAnaly.h"

@implementation BXHResponse (ResultAnaly)

- (NSString *)code
{
    return self.responseObject[@"StatusCode"];
}

- (NSString *)message
{
    
    return self.responseObject[@"Info"];
}

- (id)data
{
    id obejct = self.responseObject[@"Data"];
    if ([obejct isKindOfClass:[NSNull class]])
    {
        return @[];
    }
    return obejct;
}

@end
