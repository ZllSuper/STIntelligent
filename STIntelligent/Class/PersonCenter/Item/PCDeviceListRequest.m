//
//  PCDeviceListRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/7.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCDeviceListRequest.h"

@implementation PCDeviceListRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_MaoYanAdd,[sourceDict httpBody]];;
    self.method = BXHRequestMethodGet;
}


@end
