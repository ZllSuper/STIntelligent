//
//  ODTemporaryOpenDoorRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "ODTemporaryOpenDoorRequest.h"

@implementation ODTemporaryOpenDoorRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_TemporaryInvitation,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}


@end
