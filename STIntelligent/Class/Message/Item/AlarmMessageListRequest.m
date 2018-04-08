//
//  AlarmMessageListRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/24.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AlarmMessageListRequest.h"

@implementation AlarmMessageListRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_MessageList,[sourceDict httpBody]];;
    self.method = BXHRequestMethodGet;
}


@end
