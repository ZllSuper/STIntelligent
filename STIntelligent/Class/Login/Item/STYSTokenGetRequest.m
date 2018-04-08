//
//  STYSTokenGetRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/24.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "STYSTokenGetRequest.h"

@implementation STYSTokenGetRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_YSTokenGet,[sourceDict httpBody]];;
    self.method = BXHRequestMethodGet;
}


@end
