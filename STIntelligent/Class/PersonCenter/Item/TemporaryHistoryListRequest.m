//
//  TemporaryHistoryListRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "TemporaryHistoryListRequest.h"

@implementation TemporaryHistoryListRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_TemporaryInvitation,[sourceDict httpBody]];;
    self.method = BXHRequestMethodGet;
}


@end
