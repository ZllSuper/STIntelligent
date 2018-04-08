//
//  PCCommunityListRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/29.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityListRequest.h"

@implementation PCCommunityListRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_CommunityAbout,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}


@end
