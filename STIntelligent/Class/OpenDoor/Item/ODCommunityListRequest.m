//
//  ODCommunityListRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "ODCommunityListRequest.h"

@implementation ODCommunityListRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_CommunityDoor,[sourceDict httpBody]];;
    self.method = BXHRequestMethodGet;
}


@end
