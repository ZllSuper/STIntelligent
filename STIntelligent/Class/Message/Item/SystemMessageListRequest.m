//
//  SystemMessageListRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "SystemMessageListRequest.h"

@implementation SystemMessageListRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_MessageList,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}


@end
