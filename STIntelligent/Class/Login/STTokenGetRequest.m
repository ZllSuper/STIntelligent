//
//  STTokenGetRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "STTokenGetRequest.h"

@implementation STTokenGetRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_TokenGet,[sourceDict httpBody]];;
    self.method = BXHRequestMethodGet;
}

@end
