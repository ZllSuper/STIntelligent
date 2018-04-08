//
//  PCHelpListRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/26.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCHelpListRequest.h"

@implementation PCHelpListRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_HelpList,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}

@end
