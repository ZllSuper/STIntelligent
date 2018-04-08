//
//  STTokenLoginRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "STTokenLoginRequest.h"

@implementation STTokenLoginRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_Login,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}

@end
