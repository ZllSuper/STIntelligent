//
//  PCLogoutRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCLogoutRequest.h"

@implementation PCLogoutRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_PushUpdate,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}


@end
