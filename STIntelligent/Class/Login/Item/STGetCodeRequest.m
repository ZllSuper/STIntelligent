//
//  STGetCodeRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "STGetCodeRequest.h"

@implementation STGetCodeRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_CodeGet,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}

@end
