//
//  ViceCardOpenDoorRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "ViceCardOpenDoorRequest.h"

@implementation ViceCardOpenDoorRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_ViceCardInvitation,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}


@end
